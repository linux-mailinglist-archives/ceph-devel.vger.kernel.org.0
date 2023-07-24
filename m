Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD9975F665
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Jul 2023 14:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjGXMew (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Jul 2023 08:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjGXMeu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 24 Jul 2023 08:34:50 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CCCE77;
        Mon, 24 Jul 2023 05:34:49 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-9926623e367so762427166b.0;
        Mon, 24 Jul 2023 05:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690202088; x=1690806888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GtjbXdCKbfVMfORgAIzayVmKFLQECBrfXS5i7Chni7s=;
        b=NkA6GTqm0/4nB98WdL7U70NYQX+ASOv/su4VpYtSpkb7bTCBTSFcUnjF/Cv8U1jrIk
         QFkI6BimVgqxYCZN743nYpsjBCxzRi0nUhxCUnhtHvk+JwaWn4bWGIftJq+UqwjRZ/C/
         AQyK+mmSej3TtrAeuWo/gTsLyVFOlFxhlsw+3yHNHDgTMtbpR7ohrjzKp8ceyGRcxkPY
         D0jSq0pfoi7PmOe5d4LzubKfKkqyGoXmgM6kRbiOUkruzDYQBwsI9Zlhbz/nIXmgxaWK
         +TNsnzxsiS7FYOTmsVpNVF8JXm0aBbZN+JvF8GbK7P2d9xotEqFrrOyaLOW9Po1UA7Em
         Hh4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690202088; x=1690806888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GtjbXdCKbfVMfORgAIzayVmKFLQECBrfXS5i7Chni7s=;
        b=lygmTE9EhkRndZ8hEkbjXOud/ulV596KNg1JBKBBxMEybKiF9NzAVL+hniEabHbgpq
         Z2xZRlsJDWZPJUP6pBRA+AowwNmyeWY9oPYpGqU7s2ulhChrHXc7+2KwWjj37L+FxS+K
         ZmLdVNnLqKVWdDbOrdlJp+Ec/caBD2REzdef92LFfU/+S1/JaOe8UAivu30unMTuwfcN
         N/BhPBRBDfXK2kIkM1U1dAp/KQla9DwkNd1oRyy2iKNSIKxL4bIsdzBV4RTqLbyXsQmB
         w9yCGOYmlGMx5wDj6OsvvP3Uzqjwuc9d/TgMWv4t+bmB7U46whjXFkYVYkby91rqDoli
         3M8Q==
X-Gm-Message-State: ABy/qLYem2BbsJ+WAr+m8bHCikOamZS4dARsHzAqzxaJG6EmxULkIujy
        Iv14nMsoQJUBdPBqsfocsiobocOoLuB39Qa/jf3GxDxHNf4=
X-Google-Smtp-Source: APBJJlEDkxbgeC7MKhvw11vUWK0zqFnSI9lkkghAnGaIx5uh4XZkRHDygaLB9MRvQ0zWKZLLOnIdflqt0yTBzQW2nY8=
X-Received: by 2002:a17:906:9bf6:b0:993:ec93:a5ef with SMTP id
 de54-20020a1709069bf600b00993ec93a5efmr9236418ejc.47.1690202088098; Mon, 24
 Jul 2023 05:34:48 -0700 (PDT)
MIME-Version: 1.0
References: <20230724084214.321005-1-xiubli@redhat.com> <CAOi1vP9Yygpavo8fS=Tz8YGeQJ7Wmieo=14+HS20+MSMErb79A@mail.gmail.com>
 <e28b9ea0-a62c-5aae-50d0-bc092675e20d@redhat.com>
In-Reply-To: <e28b9ea0-a62c-5aae-50d0-bc092675e20d@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 24 Jul 2023 14:34:36 +0200
Message-ID: <CAOi1vP_80f8v_3c9O0O2AW7kB3YCv9TF4rUXjZHFgkXb4ZLZyA@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: defer stopping the mdsc delayed_work
To:     Xiubo Li <xiubli@redhat.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
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

On Mon, Jul 24, 2023 at 2:20=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 7/24/23 19:12, Ilya Dryomov wrote:
> > On Mon, Jul 24, 2023 at 10:44=E2=80=AFAM <xiubli@redhat.com> wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> Flushing the dirty buffer may take a long time if the Rados is
> >> overloaded or if there is network issue. So we should ping the
> >> MDSs periodically to keep alive, else the MDS will blocklist
> >> the kclient.
> >>
> >> Cc: stable@vger.kernel.org
> > Hi Xiubo,
> >
> > The stable tag doesn't make sense here as this commit enhances commit
> > 2789c08342f7 ("ceph: drop the messages from MDS when unmounting") which
> > isn't upstream.  It should probably just be folded there.
>
> No, Ilya. This is not an enhancement for commit 2789c08342f7.
>
> They are for different issues here. This patch just based on that. We
> can apply this first and then I can rebase the testing branch.

Ah, thanks for letting me know.  Please go ahead and structure it that
way in the testing branch.  As it is, it conflicts heavily as the enum
that it adds a new member to was added in commit 2789c08342f7.

                Ilya
