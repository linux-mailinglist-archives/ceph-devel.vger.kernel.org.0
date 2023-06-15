Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A28731935
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Jun 2023 14:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241004AbjFOMuu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 15 Jun 2023 08:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241931AbjFOMup (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 15 Jun 2023 08:50:45 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A18D2130
        for <ceph-devel@vger.kernel.org>; Thu, 15 Jun 2023 05:50:44 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-51a2661614cso910566a12.2
        for <ceph-devel@vger.kernel.org>; Thu, 15 Jun 2023 05:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686833443; x=1689425443;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fFo/acdoICDEAZiM1ytRgDe4niTXx2xMFTIZxoV/Vu4=;
        b=O+IwVmAh4CQ9R3i2a10rmpCaBp0mfjN09ZLTGh/e2Yd3xcqxY3LSQ3DpggIDoa37gq
         23OOSI7Kx11P7z22t/6JWqOcqeUN25agLvVao/BW167hQK0+Zpnhy5vEEtGbuuWPSv8p
         zgUi0wY76yo1dVhwBrqkAhF+Hgvq5ctxi8AcJQwZjP+uuTC2Np+Y0723LVXIwSiyPWWf
         dtm8eWfmJhggcphq7Mky8gyqA12XE3HWXooa7xAsqxB12Tqt3dpGKNjjoMndJSfrK3VR
         i0+Pc9/ugkuLYncSbHNXIJcFWSd5TCkwFpy/xYlasci0/CpulU6EfQlub2Xq58GK+xPP
         +j+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686833443; x=1689425443;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fFo/acdoICDEAZiM1ytRgDe4niTXx2xMFTIZxoV/Vu4=;
        b=JrOliTzmERrEvTQ0pkuk3FFqf5aSURuwJ50/fAZifwGMMeb9F7HEiwCIFTaBr49uu2
         EvuAx4CQAYLhiA6lKmZuuHRF/OEUUJTrFIL4q/nU+GvOsi3URXYrlnY28I2igL0l2u4J
         03r/QMINx152pNg+9G5+7rS+j3oY0eMcm2I8JYfuPdgYorNuPAvVM3B54HucXkiL11iw
         Rkh2RANWACmriDJmCdmdZvA9n5BhdqvOBWoeLkmj/dDr93d8c47WkVANV/41Sdispe7P
         BWaz4TfXukj5+78rXpBXCkaGYNmesAKhmgjChVPsQyYT2eif31QjSho0sOA4StlR926d
         +nTw==
X-Gm-Message-State: AC+VfDxdGur/83C8RWJz9rLrW0F+2h0d+UUM0A+wqXX4UdQXrb4NSEj1
        L65f0boaBYd/2nWOfqrDUcsY2ojJaQiQFIq7+py5MkeGHPY=
X-Google-Smtp-Source: ACHHUZ6XDzCujKwwAsVIkiwrrYe4rJ0tiaQn/iW4gx3l9yeMWa8HXMbI4hWnF2xY0RmCpqo5sAs9rduUPdbU22OzgKI=
X-Received: by 2002:a17:907:705:b0:978:96ba:f987 with SMTP id
 xb5-20020a170907070500b0097896baf987mr19469262ejb.10.1686833442517; Thu, 15
 Jun 2023 05:50:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230614013025.291314-1-xiubli@redhat.com> <20230614013025.291314-2-xiubli@redhat.com>
 <CAOi1vP-zgScbF0uoshqtgMToCZ8bkSaa6B2FYs0qvVrEKMDKaA@mail.gmail.com> <52379a5b-9480-1117-2bb6-91dbd967c2be@redhat.com>
In-Reply-To: <52379a5b-9480-1117-2bb6-91dbd967c2be@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 15 Jun 2023 14:50:30 +0200
Message-ID: <CAOi1vP_aqnO0vCed8Uwh8tMpVdjr0RTcR9BuoMRXY4E0p6bG9g@mail.gmail.com>
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

On Thu, Jun 15, 2023 at 3:49=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 6/14/23 16:21, Ilya Dryomov wrote:
> > On Wed, Jun 14, 2023 at 3:33=E2=80=AFAM <xiubli@redhat.com> wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> This will help print the fsid and client's global_id in debug logs,
> >> and also print the function names.
> >>
> >> URL: https://tracker.ceph.com/issues/61590
> >> Cc: Patrick Donnelly <pdonnell@redhat.com>
> >> Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>
> >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >> ---
> >>   include/linux/ceph/ceph_debug.h | 44 +++++++++++++++++++++++++++++++=
+-
> >>   1 file changed, 43 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/include/linux/ceph/ceph_debug.h b/include/linux/ceph/ceph=
_debug.h
> >> index d5a5da838caf..26b9212bf359 100644
> >> --- a/include/linux/ceph/ceph_debug.h
> >> +++ b/include/linux/ceph/ceph_debug.h
> >> @@ -19,12 +19,22 @@
> >>          pr_debug("%.*s %12.12s:%-4d : " fmt,                         =
   \
> >>                   8 - (int)sizeof(KBUILD_MODNAME), "    ",            =
   \
> >>                   kbasename(__FILE__), __LINE__, ##__VA_ARGS__)
> >> +#  define dout_client(client, fmt, ...)                              =
          \
> >> +       pr_debug("%.*s %12.12s:%-4d : [%pU %lld] " fmt,               =
  \
> >> +                8 - (int)sizeof(KBUILD_MODNAME), "    ",             =
  \
> >> +                kbasename(__FILE__), __LINE__,                       =
  \
> >> +                &client->fsid, client->monc.auth->global_id,         =
  \
> >> +                ##__VA_ARGS__)
> >>   # else
> >>   /* faux printk call just to see any compiler warnings. */
> >>   #  define dout(fmt, ...)       do {                            \
> >>                  if (0)                                          \
> >>                          printk(KERN_DEBUG fmt, ##__VA_ARGS__);  \
> >>          } while (0)
> >> +#  define dout_client(client, fmt, ...)        do {                  =
  \
> >> +               if (0)                                          \
> >> +                       printk(KERN_DEBUG fmt, ##__VA_ARGS__);  \
> >> +       } while (0)
> >>   # endif
> >>
> >>   #else
> >> @@ -33,7 +43,39 @@
> >>    * or, just wrap pr_debug
> >>    */
> >>   # define dout(fmt, ...)        pr_debug(" " fmt, ##__VA_ARGS__)
> >> -
> >> +# define dout_client(client, fmt, ...)                               =
  \
> >> +       pr_debug("[%pU %lld] %s: " fmt, &client->fsid,                =
  \
> >> +                client->monc.auth->global_id, __func__,              =
  \
> >> +                ##__VA_ARGS__)
> >>   #endif
> >>
> >> +# define pr_notice_client(client, fmt, ...)                          =
  \
> >> +       pr_notice("[%pU %lld] %s: " fmt, &client->fsid,               =
  \
> >> +                 client->monc.auth->global_id, __func__,             =
  \
> >> +                 ##__VA_ARGS__)
> > Hi Xiubo,
> >
> > We definitely don't want the framework to include function names in
> > user-facing messages (i.e. in pr_* messages).  In the example that
> > spawned this series ("ceph: mds3 session blocklisted"), it's really
> > irrelevant to the user which function happens to detect blocklisting.
> >
> > It's a bit less clear-cut for dout() messages, but honestly I don't
> > think it's needed there either.  I know that we include it manually in
> > many places but most of the time it's actually redundant.
>
> The function name will include the most info needed in the log messages,
> before almost all the log messages will add that explicitly or will add
> one function name directly. Which may make the length of the 'fmt'
> string exceeded 80 chars.
>
> If this doesn't make sense I will remove this from the framework.

I'm fine with keeping it for dout() messages.  To further help with
line lengths, how about naming the new macro doutc()?  Since it takes
an extra argument before the format string, it feels distinctive enough
despite it being just a single character.

Thanks,

                Ilya
