Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4305F91AA3
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Aug 2019 03:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfHSBYl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Sun, 18 Aug 2019 21:24:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59542 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726132AbfHSBYl (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 18 Aug 2019 21:24:41 -0400
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com [209.85.167.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7A32E6E78C
        for <ceph-devel@vger.kernel.org>; Mon, 19 Aug 2019 01:24:40 +0000 (UTC)
Received: by mail-lf1-f69.google.com with SMTP id g4so246330lfj.11
        for <ceph-devel@vger.kernel.org>; Sun, 18 Aug 2019 18:24:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qyvt5iAn14FGw4hU/vwTAskBP/8j8x4cxfD/5zAIKEE=;
        b=Xd6qIbJG4i6mD5Jx+sSZr1NQnrgKeoJFOvwCDxKTs89+fyNJf3KjwqJR9wBbvazP9e
         KNKMM/QaDEnUbJp6q1Nju5bhzx1gwyCQeif0l+J99E7leLnSe0sW+g97hGpN63icp5RX
         EMSni5Or2LuGOMl36FqRb/92NfjtBmjl1r+1yQTyP3FpwlACY0AbYi2HvW+sImrQ5dzw
         TEhjynXPAMmGGTTilaGi+vuQf1d9ASMGKqDvNsicI0VZXjpwAw8Jy8lxAJQRM36scmly
         p+FUiPY7qzKsgdpG1aXZguMwty+9PV/NKSV/wkXYCDX+HDOEDr9j6xptFWCJuoVseDJ7
         8u+A==
X-Gm-Message-State: APjAAAVzmqJx9xJ4gKMtS4Rf6BeGPC7vxyRmedgft3OTcdMo7RN6cbBA
        70iwtLBIkVVxRUG4jwxrRShnvOlO55W+V7Uk6NnyACRHAavrKoF5HSwJi7cYocVK3ktbx8C2Zvz
        6hxSxYJxn5V59SynTO/KTudxwXx5qn59blBRazA==
X-Received: by 2002:a19:ca0d:: with SMTP id a13mr10570641lfg.110.1566177879060;
        Sun, 18 Aug 2019 18:24:39 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyqJwjEtUFoxdZp+m5gPd3vwf+wAwYgPujEYH/Dr8RK7Fn+763dVK0WzOBPiwXihnZ2BRWNAiZ/z8gIdkrgmA0=
X-Received: by 2002:a19:ca0d:: with SMTP id a13mr10570635lfg.110.1566177878760;
 Sun, 18 Aug 2019 18:24:38 -0700 (PDT)
MIME-Version: 1.0
References: <ord0h3gy6w.fsf@lxoliva.fsfla.org>
In-Reply-To: <ord0h3gy6w.fsf@lxoliva.fsfla.org>
From:   Brad Hubbard <bhubbard@redhat.com>
Date:   Mon, 19 Aug 2019 11:24:27 +1000
Message-ID: <CAF-wwdEsyDC=X90ECi05a3FxWwbkv-gTTZAyfnB-N=K8KgNAPw@mail.gmail.com>
Subject: Re: fix for hidden corei7 requirement in binary packages
To:     Alexandre Oliva <oliva@gnu.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

+dev@ceph

On Sun, Aug 18, 2019 at 9:50 AM Alexandre Oliva <oliva@gnu.org> wrote:
>
> Hi,
>
> After upgrading some old Phenom servers from Fedora/Freed-ora 29 to
> 30's, to ceph-14.2.2, I was surprised by very early crashes of both
> ceph-mon and ceph-osd.  After ruling out disk and memory corruption, I
> investigated a bit noticed all of them crashed during pre-main() init
> section processing, at an instruction not available on the Phenom X6
> processors that support sse4a, but not e.g. sse4.1.
>
> It turns out that much of librte is built with -march=corei7.  That's a
> little excessive, considering that x86/rte_memcpy.h would be happy
> enough with -msse4.1, but not with earlier sse versions that Fedora is
> supposed to target.
>
> I understand rte_memcpy.h is meant for better performance, inlining
> fixed-size and known-alignment implementations of memcpy into users.
> Alas, that requires setting a baseline target processor, and you'll only
> get as efficient an implementation as what's built in.
>
> I noticed an attempt for dynamic selection, but GCC rightfully won't
> inline across different target flags, so we'd have to give up inlining
> to get better dynamic behavior.  The good news is that glibc already
> offers dynamic selection of memcpy implementations, so hopefully the
> impact of this change won't be much worse than that of enabling dynamic
> selection, without the complications.
>
> If that's not good enough, compiling ceph with flags that enable SSE4.1,
> AVX2 or AVX512, or with a -march flag that implicitly enables them,
> would restore current performance, but without that, you will (with the
> patch below) get a package that runs on a broader range of processors,
> that the base distro (through the compiler's baseline flags) chooses to
> support.  It's not nice when you install a package on a processor that's
> supposed to be supported and suddenly you're no longer sure it is ;-)
>
> Perhaps building a shared librte, so that one could build and install
> builds targeting different ISA versions, without having to rebuild all
> of ceph, would be a reasonable way to address the better tuning of these
> performance-critical bits.
>
>
>
> src/spdk/dpdk:
>
> diff --git a/lib/librte_eal/common/include/arch/x86/rte_memcpy.h b/lib/librte_eal/common/include/arch/x86/rte_memcpy.h
> index 7b758094d..ce714bf02 100644
> --- a/lib/librte_eal/common/include/arch/x86/rte_memcpy.h
> +++ b/lib/librte_eal/common/include/arch/x86/rte_memcpy.h
> @@ -40,6 +40,16 @@ extern "C" {
>  static __rte_always_inline void *
>  rte_memcpy(void *dst, const void *src, size_t n);
>
> +#ifndef RTE_MACHINE_CPUFLAG_SSE4_1
> +
> +static __rte_always_inline void *
> +rte_memcpy(void *dst, const void *src, size_t n)
> +{
> +  return memcpy(dst, src, n);
> +}
> +
> +#else /* RTE_MACHINE_CPUFLAG_SSE4_1 */
> +
>  #ifdef RTE_MACHINE_CPUFLAG_AVX512F
>
>  #define ALIGNMENT_MASK 0x3F
> @@ -869,6 +879,8 @@ rte_memcpy(void *dst, const void *src, size_t n)
>                 return rte_memcpy_generic(dst, src, n);
>  }
>
> +#endif /* RTE_MACHINE_CPUFLAG_SSE4_1 */
> +
>  #ifdef __cplusplus
>  }
>  #endif
> diff --git a/mk/machine/default/rte.vars.mk b/mk/machine/default/rte.vars.mk
> index df08d3b03..6bf695849 100644
> --- a/mk/machine/default/rte.vars.mk
> +++ b/mk/machine/default/rte.vars.mk
> @@ -27,4 +27,4 @@
>  # CPU_LDFLAGS =
>  # CPU_ASFLAGS =
>
> -MACHINE_CFLAGS += -march=corei7
> +# MACHINE_CFLAGS += -march=corei7
>
>
> --
> Alexandre Oliva, freedom fighter  he/him   https://FSFLA.org/blogs/lxo
> Be the change, be Free!                 FSF Latin America board member
> GNU Toolchain Engineer                        Free Software Evangelist
> Hay que enGNUrecerse, pero sin perder la terGNUra jamás - Che GNUevara



-- 
Cheers,
Brad
