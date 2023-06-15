Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69827731A58
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Jun 2023 15:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239087AbjFONo3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 15 Jun 2023 09:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344525AbjFONoZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 15 Jun 2023 09:44:25 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2B41A3
        for <ceph-devel@vger.kernel.org>; Thu, 15 Jun 2023 06:44:23 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-9827109c6e9so244918266b.3
        for <ceph-devel@vger.kernel.org>; Thu, 15 Jun 2023 06:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686836662; x=1689428662;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=31/YIo9kuB93AXDUInaHTWNmOcGjkFbDVg4P4YGfE+g=;
        b=VOPvlx7SA2k2yzqJerrQyH+HU48aDRgeCbR4UX9icE5YHf4rTVTrecQtC0NpDRdUTl
         O70seNuaiyF4/6BTCAtDESZP/cm80SM5OBs4R/cz+BpDBVrWF4FyvI65hIQgn81+1njC
         YfTdNE1AU6t2YbRMtf+ilpeLEvpT89GbzCvWWSb+H0hK4u3S/yMdq6isCA0OIl8z73Ze
         RUM1V/0AwX0uvHBlyBQSsV1f3V+hHPTRiOBJcg5tZr9PvMwVeyTD7uZ8z8+J5MfbSO9e
         XrZapUCja2J+uAYYIaT/fvtBJLvNjddKDUPXXZ+8FKtqlFj2GylDhfCwmXtNnCKy0HGD
         HfpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686836662; x=1689428662;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=31/YIo9kuB93AXDUInaHTWNmOcGjkFbDVg4P4YGfE+g=;
        b=CjDmhCnoP6yORlRLjSJG6hHq73Z3CyZS7e7xOzE5/z5I0JTZydmyDWyCteUruFrm7B
         /uwg89aZkx5fJJ8yXUh6VFD7oHV5XtIgrdQP0KaJaODbFhWR7qD62uGdSvf9qoTQjsRC
         PLAO5gkVxLVw8ALkaWa6PKe2pyTIVDyPl+gzOoRonxQKYUj8tdJemexvEgVLd1WMb4nW
         anwfq/wA8HuMemmKVOGOe+CliIFCdNkYUtmSX9Du6mT1gPQgMZ7ZQJ1pLS4GVx36VfJI
         skMlOB275nmCiigqh1KIvSReE4x6FHaFMUS6/Lk++2/TmH/dTwaMDkTZJ9/6d4OzaT2M
         VrJg==
X-Gm-Message-State: AC+VfDySp4Vx6lLNciR6SqvSovMKK0EoKGEzboInx6RqpG3Fdm88dvsj
        0HFtKAiIk6DuKWDrLlLamjKyKpITlNN6Z3/gcaa1P8Ef06U=
X-Google-Smtp-Source: ACHHUZ6l83ta1SvLPWEX4B5V6AWDaDqblp+ixXn+rCiVVn8eFzeKtheAW1NLnEL56lGYpWdSvnXGQwjcgzS9GA5QyBE=
X-Received: by 2002:a17:907:36ca:b0:978:6b18:e935 with SMTP id
 bj10-20020a17090736ca00b009786b18e935mr16348007ejc.23.1686836662207; Thu, 15
 Jun 2023 06:44:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230614013025.291314-1-xiubli@redhat.com> <20230614013025.291314-2-xiubli@redhat.com>
 <CAOi1vP-zgScbF0uoshqtgMToCZ8bkSaa6B2FYs0qvVrEKMDKaA@mail.gmail.com>
 <52379a5b-9480-1117-2bb6-91dbd967c2be@redhat.com> <CAOi1vP_aqnO0vCed8Uwh8tMpVdjr0RTcR9BuoMRXY4E0p6bG9g@mail.gmail.com>
 <bd7acf07-f04f-a2f0-2a23-24e0de20e508@redhat.com>
In-Reply-To: <bd7acf07-f04f-a2f0-2a23-24e0de20e508@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 15 Jun 2023 15:44:09 +0200
Message-ID: <CAOi1vP_mfWoCX6-r6+kB2Cpg_moXQjAheq5FfV-CmJtfKv7hQQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] ceph: add the *_client debug macros support
To:     Xiubo Li <xiubli@redhat.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com, khiremat@redhat.com,
        pdonnell@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 15, 2023 at 2:57=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 6/15/23 20:50, Ilya Dryomov wrote:
> > On Thu, Jun 15, 2023 at 3:49=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wr=
ote:
> >>
> >> On 6/14/23 16:21, Ilya Dryomov wrote:
> >>> On Wed, Jun 14, 2023 at 3:33=E2=80=AFAM <xiubli@redhat.com> wrote:
> >>>> From: Xiubo Li <xiubli@redhat.com>
> >>>>
> >>>> This will help print the fsid and client's global_id in debug logs,
> >>>> and also print the function names.
> >>>>
> >>>> URL: https://tracker.ceph.com/issues/61590
> >>>> Cc: Patrick Donnelly <pdonnell@redhat.com>
> >>>> Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>
> >>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >>>> ---
> >>>>    include/linux/ceph/ceph_debug.h | 44 ++++++++++++++++++++++++++++=
++++-
> >>>>    1 file changed, 43 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/include/linux/ceph/ceph_debug.h b/include/linux/ceph/ce=
ph_debug.h
> >>>> index d5a5da838caf..26b9212bf359 100644
> >>>> --- a/include/linux/ceph/ceph_debug.h
> >>>> +++ b/include/linux/ceph/ceph_debug.h
> >>>> @@ -19,12 +19,22 @@
> >>>>           pr_debug("%.*s %12.12s:%-4d : " fmt,                      =
      \
> >>>>                    8 - (int)sizeof(KBUILD_MODNAME), "    ",         =
      \
> >>>>                    kbasename(__FILE__), __LINE__, ##__VA_ARGS__)
> >>>> +#  define dout_client(client, fmt, ...)                            =
            \
> >>>> +       pr_debug("%.*s %12.12s:%-4d : [%pU %lld] " fmt,             =
    \
> >>>> +                8 - (int)sizeof(KBUILD_MODNAME), "    ",           =
    \
> >>>> +                kbasename(__FILE__), __LINE__,                     =
    \
> >>>> +                &client->fsid, client->monc.auth->global_id,       =
    \
> >>>> +                ##__VA_ARGS__)
> >>>>    # else
> >>>>    /* faux printk call just to see any compiler warnings. */
> >>>>    #  define dout(fmt, ...)       do {                            \
> >>>>                   if (0)                                          \
> >>>>                           printk(KERN_DEBUG fmt, ##__VA_ARGS__);  \
> >>>>           } while (0)
> >>>> +#  define dout_client(client, fmt, ...)        do {                =
    \
> >>>> +               if (0)                                          \
> >>>> +                       printk(KERN_DEBUG fmt, ##__VA_ARGS__);  \
> >>>> +       } while (0)
> >>>>    # endif
> >>>>
> >>>>    #else
> >>>> @@ -33,7 +43,39 @@
> >>>>     * or, just wrap pr_debug
> >>>>     */
> >>>>    # define dout(fmt, ...)        pr_debug(" " fmt, ##__VA_ARGS__)
> >>>> -
> >>>> +# define dout_client(client, fmt, ...)                             =
    \
> >>>> +       pr_debug("[%pU %lld] %s: " fmt, &client->fsid,              =
    \
> >>>> +                client->monc.auth->global_id, __func__,            =
    \
> >>>> +                ##__VA_ARGS__)
> >>>>    #endif
> >>>>
> >>>> +# define pr_notice_client(client, fmt, ...)                        =
    \
> >>>> +       pr_notice("[%pU %lld] %s: " fmt, &client->fsid,             =
    \
> >>>> +                 client->monc.auth->global_id, __func__,           =
    \
> >>>> +                 ##__VA_ARGS__)
> >>> Hi Xiubo,
> >>>
> >>> We definitely don't want the framework to include function names in
> >>> user-facing messages (i.e. in pr_* messages).  In the example that
> >>> spawned this series ("ceph: mds3 session blocklisted"), it's really
> >>> irrelevant to the user which function happens to detect blocklisting.
> >>>
> >>> It's a bit less clear-cut for dout() messages, but honestly I don't
> >>> think it's needed there either.  I know that we include it manually i=
n
> >>> many places but most of the time it's actually redundant.
> >> The function name will include the most info needed in the log message=
s,
> >> before almost all the log messages will add that explicitly or will ad=
d
> >> one function name directly. Which may make the length of the 'fmt'
> >> string exceeded 80 chars.
> >>
> >> If this doesn't make sense I will remove this from the framework.
> > I'm fine with keeping it for dout() messages.  To further help with
> > line lengths, how about naming the new macro doutc()?  Since it takes
> > an extra argument before the format string, it feels distinctive enough
> > despite it being just a single character.
>
> What about the others macros ? Such as for the 'pr_info_client()',etc ?

pr_info() and friends are used throughout the kernel, so the name is
very recognizable.  We also have a lot fewer of them compared to douts,
so I would stick with pr_info_client() (i.e. no shorthands).

Thanks,

                Ilya
