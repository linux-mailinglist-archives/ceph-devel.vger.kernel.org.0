Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFEF6F892C
	for <lists+ceph-devel@lfdr.de>; Fri,  5 May 2023 20:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbjEES7h (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 5 May 2023 14:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233437AbjEES72 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 5 May 2023 14:59:28 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1DE22707
        for <ceph-devel@vger.kernel.org>; Fri,  5 May 2023 11:59:19 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-965fc25f009so84215766b.3
        for <ceph-devel@vger.kernel.org>; Fri, 05 May 2023 11:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683313158; x=1685905158;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PjEOPxGsGIS8P95mhdj5EPV7laRtlh2fnRQQpuxT71Q=;
        b=syVohNrsraJNFkxkbsfUQNrw4G6cMCdlXOZfvCs9LwfK2OYpwkDXtCbq+i++4U5x5Y
         OJyDmgPK0TjxAq0Hgjb6k++ArTCjobaEOVU6EhYwcI+c8znAUL/9wA4bSdp+oeC1PXPW
         PRZq3hqWNflcueW2bFvpLnIEoIihiAtthUStxvXg3Mw/0wWLFwtvZNpnLhNThFV4wH3U
         /fQTjs9gU7VZu50Jp/5xEY4SK7klUj0mDr3Adl8+d75Jl3Zd/LfiKGVwWBbgmSqKY+aB
         V4Y+cUk5NS1thKXvw31Mi7RborBInkj/t5DMNLmtRkT4Gzl5UyelI0cvZMDZV5sf43XT
         lSYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683313158; x=1685905158;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PjEOPxGsGIS8P95mhdj5EPV7laRtlh2fnRQQpuxT71Q=;
        b=jb0ADYmmY06p3Pytsd8eh0fHp28A+OLA7xacNCzEJtkeb86hZ2FmanpOKGL6AFWONk
         uD/9lVAFsq8zVrXXrGekc7J65Y3cUh4GgxcmMiBQB0gKH4OvyCEefzmOo2ryU+x+NvM8
         lUVu+NKObeKqkl0DcK8cY/RdyxI7r2UlXWN6zAYofnku3zp8B6kI8fgJrRmLgWAV9Gpe
         Heoor2v3XHZTWmN0tjmXIN8OEQ0I3atoi06b01YqfajHkXM0y7rMWeP0/UmmApfKy4O4
         EbUaMr8WIx5AYC2dNg7n+9L7l6h/y9RHuUQJPdA3kLzCwXxNncXGvbgLXejNPb2KVYSe
         MWEQ==
X-Gm-Message-State: AC+VfDwo2imKT5q7CXSKMUTN67hRLYzS9s7ZjE6J1A7w7vTQ8weHFpNc
        LIgWvZ3vXpVGbz2wh+ak+Ajx54eS0FTaChKpyko=
X-Google-Smtp-Source: ACHHUZ51o8lJzCbbAq2bslX4NQoe+FxitiJt95c6GR4zQxAtqiwPbuWOgPuhPj59T7goJhQXddB58Zq5+0MnjGNPpXI=
X-Received: by 2002:a17:907:7d94:b0:961:b0:3e0e with SMTP id
 oz20-20020a1709077d9400b0096100b03e0emr2345601ejc.30.1683313158034; Fri, 05
 May 2023 11:59:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230504182810.165185-1-idryomov@gmail.com> <87wn1nm2bu.fsf@brahms.olymp>
In-Reply-To: <87wn1nm2bu.fsf@brahms.olymp>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 5 May 2023 20:59:06 +0200
Message-ID: <CAOi1vP_eqNTrQMX1jC-jXJTKZKb=GifQtFfzgrsMXQffBgQuYw@mail.gmail.com>
Subject: Re: [GIT PULL] Ceph updates for 6.4-rc1
To:     =?UTF-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
Cc:     Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
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

On Fri, May 5, 2023 at 1:42=E2=80=AFPM Lu=C3=ADs Henriques <lhenriques@suse=
.de> wrote:
>
>
> [re-arranged CC list]
>
> Ilya Dryomov <idryomov@gmail.com> writes:
>
> > Hi Linus,
> >
> > The following changes since commit 457391b0380335d5e9a5babdec90ac53928b=
23b4:
> >
> >   Linux 6.3 (2023-04-23 12:02:52 -0700)
> >
> > are available in the Git repository at:
> >
> >   https://github.com/ceph/ceph-client.git tags/ceph-for-6.4-rc1
> >
> > for you to fetch changes up to db2993a423e3fd0e4878f4d3ac66fe717f5f072e=
:
> >
> >   ceph: reorder fields in 'struct ceph_snapid_map' (2023-04-30 12:37:28=
 +0200)
> >
> > ----------------------------------------------------------------
> > A few filesystem improvements, with a rather nasty use-after-free fix
> > from Xiubo intended for stable.
>
> Thank you, Ilya.  It's unfortunate that fscrypt support misses yet anothe=
r
> merge window, but I guess there are still a few loose ends.
>
> Is there a public list of issues (kernel or ceph proper) still to be
> sorted out before this feature gets merged?  Or is this just a lack of
> confidence on the implementation stability?

Hi Lu=C3=ADs,

When fscrypt work got supposedly finalized it was already pretty late
in the cycle and it just didn't help that upon pulling it I encountered
a subtly broken patch which was NACKed before ("libceph: defer removing
the req from osdc just after req->r_callback") and also that "optionally
bypass content encryption" leftover.  It got addressed but too late for
such a large change to be staged for 6.4 merge window.

I would encourage everyone to make another pass over the entire series
to make sure that there is nothing eyebrows-raising left there and that
it really feels solid.

Thanks,

                Ilya
