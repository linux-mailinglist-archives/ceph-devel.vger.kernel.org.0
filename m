Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76364246338
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Aug 2020 11:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgHQJYJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Aug 2020 05:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgHQJYI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 17 Aug 2020 05:24:08 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB52C061389;
        Mon, 17 Aug 2020 02:24:08 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id g14so17016680iom.0;
        Mon, 17 Aug 2020 02:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pzS+9+lr2xk/rP+YjZ4CjcDZPGT5BpmB3I8mWcl+aVY=;
        b=LX05aoU4ZVoS9xaRC8X67z1mTc/+5idee9umeA30L1hzpVy+ZSCFEQz+eTK7+pEQgK
         eecOTM44AXzxjFkPqTtFBBpBf8R4NxoR7i3hpXKd8PTKtR93o+HZByEZHzgTvNpb4R1j
         V7Z6/oZ5xDa550yylWG6lLV57SfGssiexFU98JGm4viuN5+0/KnunlKsDr3ZjoSqxfgx
         CJ4PgFiF1TilwDvtgoiCAlPLgkbuv4dmh2AUvvn0UjAHlb88CrBRzfs0FMmKXvheGozS
         lfBhHO277RftiovjJQ82OGT8nTjFn9asbMIE4i4XteBqo9nS0FbHp4N02ynaTzojEuUr
         3pvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pzS+9+lr2xk/rP+YjZ4CjcDZPGT5BpmB3I8mWcl+aVY=;
        b=kU7oAovsfNlznW428rT9Bu4x791PNCCVc09TSsR4bdyAsNZ0rSVBaIjaN5XX0+/qMc
         vdq8sOy/2God1nx4UbS4+6Xu76hIOS9ZSqHCEF3o2v1vlo9HVtUd0ef9LqPNmBTebBDv
         LU+PeaJ6BEUB9Cg7FG7xrp02J2wUmciaIz/Y8UNOGd0RxTPFKWK9woiqsiJZBmman0cg
         7tzLEuwUTgPfhsatP+hZbg6A+O0MOwpvIRvW+gn//+0ywqAIPtUPq+vLCyp9ePwOAqsk
         ctzQvfTDsSzMCG720xpYShdT6fQbTrdRK2CetbpL5QnozFCDWQ3NFd5bB0s5AooGhHaL
         kUhA==
X-Gm-Message-State: AOAM530mcX9wukGtIzTZ0qvIn+SCWxg8lI1bKquqBclWp8/NSF2RgHgH
        CEE7gtjIZMpgBIocsvW7DreJn8aIa5I7RarHsWlRYR/0EfA=
X-Google-Smtp-Source: ABdhPJxFJXneRWWi/rpBakz3RagKmL2mkuCH1mPE+9wwmmShGsnLNvVVEtlROdtWS9xT1gEqtFNo5W/7fEMyoDcR73s=
X-Received: by 2002:a6b:bb43:: with SMTP id l64mr11709080iof.191.1597656247336;
 Mon, 17 Aug 2020 02:24:07 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1597626802.git.joe@perches.com> <fe4e9e2a544af4d00aa5c97d9288d9b4d67db1ed.1597626802.git.joe@perches.com>
In-Reply-To: <fe4e9e2a544af4d00aa5c97d9288d9b4d67db1ed.1597626802.git.joe@perches.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 17 Aug 2020 11:24:14 +0200
Message-ID: <CAOi1vP8rL6R8LqFnz10O=N4gfC2zYiZdfZbg3NkcePRvOKu7xA@mail.gmail.com>
Subject: Re: [PATCH V2 6/6] ceph_debug: Remove now unused dout macro definitions
To:     Joe Perches <joe@perches.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Aug 17, 2020 at 3:34 AM Joe Perches <joe@perches.com> wrote:
>
> All the uses have be converted to pr_debug, so remove these.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  include/linux/ceph/ceph_debug.h | 30 ------------------------------
>  1 file changed, 30 deletions(-)
>
> diff --git a/include/linux/ceph/ceph_debug.h b/include/linux/ceph/ceph_debug.h
> index d5a5da838caf..81c0d7195f1e 100644
> --- a/include/linux/ceph/ceph_debug.h
> +++ b/include/linux/ceph/ceph_debug.h
> @@ -6,34 +6,4 @@
>
>  #include <linux/string.h>
>
> -#ifdef CONFIG_CEPH_LIB_PRETTYDEBUG
> -
> -/*
> - * wrap pr_debug to include a filename:lineno prefix on each line.
> - * this incurs some overhead (kernel size and execution time) due to
> - * the extra function call at each call site.
> - */
> -
> -# if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)
> -#  define dout(fmt, ...)                                               \
> -       pr_debug("%.*s %12.12s:%-4d : " fmt,                            \
> -                8 - (int)sizeof(KBUILD_MODNAME), "    ",               \
> -                kbasename(__FILE__), __LINE__, ##__VA_ARGS__)
> -# else
> -/* faux printk call just to see any compiler warnings. */
> -#  define dout(fmt, ...)       do {                            \
> -               if (0)                                          \
> -                       printk(KERN_DEBUG fmt, ##__VA_ARGS__);  \
> -       } while (0)
> -# endif
> -
> -#else
> -
> -/*
> - * or, just wrap pr_debug
> - */
> -# define dout(fmt, ...)        pr_debug(" " fmt, ##__VA_ARGS__)
> -
> -#endif
> -
>  #endif
> --
> 2.26.0
>

Hi Joe,

Yeah, roughly the same thing can be achieved with +flmp instead
of just +p with PRETTYDEBUG, but PRETTYDEBUG formatting actually
predates those flags and some of us still use bash scripts from
back then.  We also have a few guides and blog entries with just
+p, but that's not a big deal.

I'd be fine with removing CONFIG_CEPH_LIB_PRETTYDEBUG since it's
disabled by default and in all major distributions, but I'm not a
fan of a wide-sweeping dout -> pr_debug change.  We do extensive
backporting to older kernels and these kind of changes are rather
annoying.  dout is shorter to type too ;)

I know that in some cases the function names are outdated or
duplicated, but I prefer fixing them gradually, along with actual
code changes in the area (i.e. similar to whitespace).

Thanks,

                Ilya
