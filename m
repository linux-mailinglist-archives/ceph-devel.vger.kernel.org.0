Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23E0791C3A
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Aug 2019 07:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbfHSFFB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Aug 2019 01:05:01 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:36505 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbfHSFFA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 19 Aug 2019 01:05:00 -0400
Received: by mail-oi1-f193.google.com with SMTP id c15so390437oic.3
        for <ceph-devel@vger.kernel.org>; Sun, 18 Aug 2019 22:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zQK9pNx01T2+xR72hMm4JcEYxOk649Li740+QxJulvk=;
        b=lYfZpkZrgxZ1K2cLrmB0nG7K1sc8W92rKW7R66OEWbVRnxumfvuJiCbLNuFQdkdgT2
         Him0mesJIGGk0QLo5hHxAmNY3FOfOT/YODv1b+al5ZJ+ow5y/6wt1OvIV+V33j04eO28
         zcJN8CIr/RKf9OuUcUSEBhSgZWEbH2LJMyGdwZFYrMKvlib0ETt9HcudsXBYKll/0B+h
         UHmNn+0GOkH11+gi1f9UAZJQi16L4VontaFk3ybA7l5/6I/O+3GgNFP+JgggAvWIqUbs
         Tv5bu6MRce5mzh7fpSjYCu3/gq8pi/GfYdiyrkDh+YXrYkL0Xu6iBzVKkTosCnrkUXnq
         S12Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zQK9pNx01T2+xR72hMm4JcEYxOk649Li740+QxJulvk=;
        b=djq6kUi4LT+1FClFMhtS4fUXoVhaR5f2MlU0cqL+98QjcvrqJzoIKxJeOJW11UfejI
         pIdOWTN9lrvhw98uzN6OQCrlnpgmxzcUMECK9MONeOix+5i1OFZ6BlDaQn18LH2zsojP
         MWb4oVVtcF1Z/mpV/BpPwgpnW3dtPO/fjTRNdpgW8fdztcxc6tGA3Pu5h31vqVyftMp/
         dVtQwiE2OXAf3j73tExyzXfNjHtR6CPnrAhBZvV504LXCiQT7QJOTcSWokebQrPFaxv5
         3q7ng+bvrYCP/d3ziGL/ldxPZgjylnooP+8m+PV34cwZNhG/okilO5JvkCUJYrJ9JRKL
         gmSA==
X-Gm-Message-State: APjAAAX3zyaka8nansmfPbIaYIGya1zYk001qHW1Mf3n4YcmU59t6k3d
        t1Be8gqG0pSBdky9UQVSvo/+epbRfADmnzCivJI=
X-Google-Smtp-Source: APXvYqx7+tx5rP0ebXVIUv9JJQJB87XGtbQt8VfjAzN0NCY/ls95X1+i2tvTSlaRDNtTusz5TZyQpGiXl4VQzv3wnWw=
X-Received: by 2002:a05:6808:4d0:: with SMTP id a16mr2666046oie.47.1566191099393;
 Sun, 18 Aug 2019 22:04:59 -0700 (PDT)
MIME-Version: 1.0
References: <ord0h3gy6w.fsf@lxoliva.fsfla.org> <CAF-wwdEsyDC=X90ECi05a3FxWwbkv-gTTZAyfnB-N=K8KgNAPw@mail.gmail.com>
In-Reply-To: <CAF-wwdEsyDC=X90ECi05a3FxWwbkv-gTTZAyfnB-N=K8KgNAPw@mail.gmail.com>
From:   kefu chai <tchaikov@gmail.com>
Date:   Mon, 19 Aug 2019 13:04:47 +0800
Message-ID: <CAJE9aOObStUp7Xqcrp6g4yOntGZ81Z7unnYJ5jBeDG=8wg=DcQ@mail.gmail.com>
Subject: Re: fix for hidden corei7 requirement in binary packages
To:     Brad Hubbard <bhubbard@redhat.com>
Cc:     Alexandre Oliva <oliva@gnu.org>,
        ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Aug 19, 2019 at 9:24 AM Brad Hubbard <bhubbard@redhat.com> wrote:
>
> +dev@ceph
>
> On Sun, Aug 18, 2019 at 9:50 AM Alexandre Oliva <oliva@gnu.org> wrote:
> >
> > Hi,
> >
> > After upgrading some old Phenom servers from Fedora/Freed-ora 29 to
> > 30's, to ceph-14.2.2, I was surprised by very early crashes of both
> > ceph-mon and ceph-osd.  After ruling out disk and memory corruption, I
> > investigated a bit noticed all of them crashed during pre-main() init
> > section processing, at an instruction not available on the Phenom X6
> > processors that support sse4a, but not e.g. sse4.1.
> >
> > It turns out that much of librte is built with -march=3Dcorei7.  That's=
 a
> > little excessive, considering that x86/rte_memcpy.h would be happy
> > enough with -msse4.1, but not with earlier sse versions that Fedora is
> > supposed to target.
> >
> > I understand rte_memcpy.h is meant for better performance, inlining
> > fixed-size and known-alignment implementations of memcpy into users.
> > Alas, that requires setting a baseline target processor, and you'll onl=
y
> > get as efficient an implementation as what's built in.
> >
> > I noticed an attempt for dynamic selection, but GCC rightfully won't
> > inline across different target flags, so we'd have to give up inlining
> > to get better dynamic behavior.  The good news is that glibc already
> > offers dynamic selection of memcpy implementations, so hopefully the
> > impact of this change won't be much worse than that of enabling dynamic
> > selection, without the complications.
> >
> > If that's not good enough, compiling ceph with flags that enable SSE4.1=
,
> > AVX2 or AVX512, or with a -march flag that implicitly enables them,
> > would restore current performance, but without that, you will (with the
> > patch below) get a package that runs on a broader range of processors,
> > that the base distro (through the compiler's baseline flags) chooses to
> > support.  It's not nice when you install a package on a processor that'=
s
> > supposed to be supported and suddenly you're no longer sure it is ;-)
> >
> > Perhaps building a shared librte, so that one could build and install
> > builds targeting different ISA versions, without having to rebuild all
> > of ceph, would be a reasonable way to address the better tuning of thes=
e
> > performance-critical bits.
> >
> >
> >
> > src/spdk/dpdk:
> >
> > diff --git a/lib/librte_eal/common/include/arch/x86/rte_memcpy.h b/lib/=
librte_eal/common/include/arch/x86/rte_memcpy.h
> > index 7b758094d..ce714bf02 100644
> > --- a/lib/librte_eal/common/include/arch/x86/rte_memcpy.h
> > +++ b/lib/librte_eal/common/include/arch/x86/rte_memcpy.h
> > @@ -40,6 +40,16 @@ extern "C" {
> >  static __rte_always_inline void *
> >  rte_memcpy(void *dst, const void *src, size_t n);
> >
> > +#ifndef RTE_MACHINE_CPUFLAG_SSE4_1
> > +
> > +static __rte_always_inline void *
> > +rte_memcpy(void *dst, const void *src, size_t n)
> > +{
> > +  return memcpy(dst, src, n);
> > +}
> > +
> > +#else /* RTE_MACHINE_CPUFLAG_SSE4_1 */
> > +
> >  #ifdef RTE_MACHINE_CPUFLAG_AVX512F
> >
> >  #define ALIGNMENT_MASK 0x3F
> > @@ -869,6 +879,8 @@ rte_memcpy(void *dst, const void *src, size_t n)
> >                 return rte_memcpy_generic(dst, src, n);
> >  }
> >
> > +#endif /* RTE_MACHINE_CPUFLAG_SSE4_1 */
> > +
> >  #ifdef __cplusplus
> >  }
> >  #endif
> > diff --git a/mk/machine/default/rte.vars.mk b/mk/machine/default/rte.va=
rs.mk
> > index df08d3b03..6bf695849 100644
> > --- a/mk/machine/default/rte.vars.mk
> > +++ b/mk/machine/default/rte.vars.mk
> > @@ -27,4 +27,4 @@
> >  # CPU_LDFLAGS =3D
> >  # CPU_ASFLAGS =3D
> >
> > -MACHINE_CFLAGS +=3D -march=3Dcorei7
> > +# MACHINE_CFLAGS +=3D -march=3Dcorei7


Hi Alexandre, thanks for the bug report and patch. the bug is tracked
by https://tracker.ceph.com/issues/41330, and a fix is posted at
https://github.com/ceph/ceph/pull/29728

> >
> >
> > --
> > Alexandre Oliva, freedom fighter  he/him   https://FSFLA.org/blogs/lxo
> > Be the change, be Free!                 FSF Latin America board member
> > GNU Toolchain Engineer                        Free Software Evangelist
> > Hay que enGNUrecerse, pero sin perder la terGNUra jam=C3=A1s - Che GNUe=
vara
>
>
>
> --
> Cheers,
> Brad
> _______________________________________________
> Dev mailing list -- dev@ceph.io
> To unsubscribe send an email to dev-leave@ceph.io



--=20
Regards
Kefu Chai
