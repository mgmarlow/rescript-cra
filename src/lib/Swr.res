type swrResponse<'data> = {
  data: option<'data>,
  error: option<string>,
  isValidating: bool,
}

@module("swr")
external useSWR: (string, string => Js.Promise.t<'data>) => swrResponse<'data> = "default"
