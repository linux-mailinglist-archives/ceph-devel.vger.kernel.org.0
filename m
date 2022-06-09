Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073C7544154
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jun 2022 04:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234298AbiFICP1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jun 2022 22:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiFICP0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jun 2022 22:15:26 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C6024F951
        for <ceph-devel@vger.kernel.org>; Wed,  8 Jun 2022 19:15:24 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id w21so19920944pfc.0
        for <ceph-devel@vger.kernel.org>; Wed, 08 Jun 2022 19:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JyPgcK1IcnecIDaQ+M0C2MwQSP2/Ad01jKf3+2n/z8M=;
        b=ESJG6zTdoayLIyvoneB8ItOCZvMKEhhIw8MDp9aLTU3H/DRZJLSzACrK1mHH7rl42T
         HJlsKn6BWIsh+Vz0H9mMBKldXrE8eNKvU46jcEC95bsRTWxvF+Mzy71KqY+QVoS7YuZX
         RIj3kcdD5Xr+BzqHGzhWIL+0wl/0oaVFOWajoV3u+46vehbF6fMMejH8qVNtyBjM7cyx
         Xc3p6QzJ9nWOD3J58iw8Larl91aFfBO6RNcBZm4RUr2q1PP7L2WttFDxqc7Gij7H2yS2
         VJkE87uKWcE9aYjrrl0jYG0L5H6RVvoJniF99BCSqUfxuhcBJWjHc3qQALHHhgtycIR/
         Cnwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JyPgcK1IcnecIDaQ+M0C2MwQSP2/Ad01jKf3+2n/z8M=;
        b=FZt7Gqp6EeAsfK+XS8NYOEiTxIhqbR4L/Y9twV/pTFcZ9npIQfiB5R9Vp7oyIMh+2n
         6fz/xJcf6JJQ3bjp3a3gSwooc8MQ1dHkxJ38urmKqCwsT2lu3nrve4qrfz3hKT+DSpPo
         OlyIbCtcebkBtPs21omm2pYHRjJj0VSNvYbZi04pKzlGxotQknYUxILOqPPDF1DE++V+
         KjDQ6bs6TnKOJic3EjnqayIkjSt+3LGGHNQ9YDZhmzsHeK14WulJifmdw0N1vfch7fEk
         YkK9rUpYBgoOyhAIjgQKKiv2oxik0UjJqK4bFYvzQqlU7+jmaNLKVEIcOq3K/q3xSjAE
         JP3Q==
X-Gm-Message-State: AOAM532D9NlhaWhcQ+CFU61sFtVd1iGCYVvLzIn4cw2yA5CvCn1T4V8s
        qT4RCY+j7T5Btkv9NE8vdNPQzGYTjHlicT0PtlE=
X-Google-Smtp-Source: ABdhPJwreM64nBbUGlOSCQMA6LhkKKgWKjDjtw9t6ICy14f7g4A7JT77Uf7Afs/J78WrpmO2LzirXXorvGe7uVNaKEU=
X-Received: by 2002:a63:8bc7:0:b0:3fc:bd28:c819 with SMTP id
 j190-20020a638bc7000000b003fcbd28c819mr31502138pge.378.1654740924265; Wed, 08
 Jun 2022 19:15:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220606233142.150457-1-jlayton@kernel.org>
In-Reply-To: <20220606233142.150457-1-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 9 Jun 2022 10:15:10 +0800
Message-ID: <CAAM7YAmguEUbX7XWc9HV0traYT-CgKWdDWV8-OyjwLc2+Tk8EQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: wait on async create before checking caps for syncfs
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The recent series of patches that add "wait on async xxxx" at various
places do not seem correct. The correct fix should make mds avoid any
wait when handling async requests.


On Wed, Jun 8, 2022 at 12:56 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Currently, we'll call ceph_check_caps, but if we're still waiting on the
> reply, we'll end up spinning around on the same inode in
> flush_dirty_session_caps. Wait for the async create reply before
> flushing caps.
>
> Fixes: fbed7045f552 (ceph: wait for async create reply before sending any cap messages)
> URL: https://tracker.ceph.com/issues/55823
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c | 1 +
>  1 file changed, 1 insertion(+)
>
> I don't know if this will fix the tx queue stalls completely, but I
> haven't seen one with this patch in place. I think it makes sense on its
> own, either way.
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 0a48bf829671..5ecfff4b37c9 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -4389,6 +4389,7 @@ static void flush_dirty_session_caps(struct ceph_mds_session *s)
>                 ihold(inode);
>                 dout("flush_dirty_caps %llx.%llx\n", ceph_vinop(inode));
>                 spin_unlock(&mdsc->cap_dirty_lock);
> +               ceph_wait_on_async_create(inode);
>                 ceph_check_caps(ci, CHECK_CAPS_FLUSH, NULL);
>                 iput(inode);
>                 spin_lock(&mdsc->cap_dirty_lock);
> --
> 2.36.1
>
