Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFCAD91D80
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Aug 2019 09:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbfHSHBG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Aug 2019 03:01:06 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:38876 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfHSHBG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 19 Aug 2019 03:01:06 -0400
Received: by mail-oi1-f194.google.com with SMTP id p124so545823oig.5
        for <ceph-devel@vger.kernel.org>; Mon, 19 Aug 2019 00:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=53tRJNdak/Zt5ROetLR/5y6GySrbm2K/eYLMa1Rn02U=;
        b=qrm3Vxkmm6a3gVeL8KrMI8UpTijKDBzFyqAp5crlsfFme2MXa8MY6A8yF3YHYlRh9X
         /L2hrXJn03cWYH1zIt4DENiavNcX6elxb8NaM8QSxa6feSi/Hjgvmhc1Wr++SHJMtXD4
         zUw2NVEFz0yOlcdtYZq9bMbl+0nZIu54ncx1rJhFXofz6RZJCmtAlCwWZpVULMvyA2Am
         Z9EBX8B0eCqtw5C7fcam9MAv9Buq6Q+lnC7KsNCXHtQlVp3SvvxInwxxrMeL9q+PBXzI
         SFSRpqhg6oHRm1GT6euN0ABqXcfhxXdHPvbG5CgKTdbH4QgNeTWi4+upMQJ0z91y2j3i
         Y68A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=53tRJNdak/Zt5ROetLR/5y6GySrbm2K/eYLMa1Rn02U=;
        b=pDu2IGJHiJMzoMYy4cjrA1cTWD7Zpj8ScxTk/QYRp2ISpOZLSuoVTc1SbqQ6jbFle9
         joI4kZ5saBtBu9tsyl1OIxRXYs5A7W/BiqmcXUR7JllY2OWanr4iYYQFl6vdnzBarcE7
         Rlv7POcA5ZFPcph4F2EiyGm6aRPmBcX8Lqy8xjvvFIUC+XgPz1mzS+8EGVVMESZxGN6R
         7XeJugftf/f6PoEg3VAgeSDvGOjsnT82FBxlbiiMlv/3OxVrkkfVpVxRZSugfjpvybZY
         RTvYleT48p5JxfdmX1wQh6tyWuDhUaIkqAnklwMRabZelf1CwYuGTzACVrIRwrd0ipnu
         io6w==
X-Gm-Message-State: APjAAAV8WReXUXKsykYoWQWgm4AHx/y6wUXzkKpZwKOyz2iJT3yW4Tih
        a2h8LtWFM3rmwiEOpa5OZbPio3/xnhoK2dznmwI=
X-Google-Smtp-Source: APXvYqxXTqh9lH8xZsSADK0NAf76p2Hqa6gapIxhhZWxsT3ca8719uUMEpdN3dcwrz8CPKvwnN80H2fMg3Emj+RrW+8=
X-Received: by 2002:a05:6808:4d0:: with SMTP id a16mr2856192oie.47.1566198064519;
 Mon, 19 Aug 2019 00:01:04 -0700 (PDT)
MIME-Version: 1.0
References: <ord0h3gy6w.fsf@lxoliva.fsfla.org> <CAF-wwdEsyDC=X90ECi05a3FxWwbkv-gTTZAyfnB-N=K8KgNAPw@mail.gmail.com>
 <CAJE9aOObStUp7Xqcrp6g4yOntGZ81Z7unnYJ5jBeDG=8wg=DcQ@mail.gmail.com>
In-Reply-To: <CAJE9aOObStUp7Xqcrp6g4yOntGZ81Z7unnYJ5jBeDG=8wg=DcQ@mail.gmail.com>
From:   kefu chai <tchaikov@gmail.com>
Date:   Mon, 19 Aug 2019 15:00:52 +0800
Message-ID: <CAJE9aOMNvOmLc9=7LLCfZTUgiyjM20vpiE8a8v9iM8CyBVJE1g@mail.gmail.com>
Subject: Re: fix for hidden corei7 requirement in binary packages
To:     Brad Hubbard <bhubbard@redhat.com>,
        Tone Zhang <tone.zhang@linaro.org>
Cc:     Alexandre Oliva <oliva@gnu.org>,
        ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

+ Tone Zhang

On Mon, Aug 19, 2019 at 1:04 PM kefu chai <tchaikov@gmail.com> wrote:
>
> On Mon, Aug 19, 2019 at 9:24 AM Brad Hubbard <bhubbard@redhat.com> wrote:
> >
> > +dev@ceph
> >
> > On Sun, Aug 18, 2019 at 9:50 AM Alexandre Oliva <oliva@gnu.org> wrote:
> > >
> > > Hi,
> > >
> > > After upgrading some old Phenom servers from Fedora/Freed-ora 29 to
> > > 30's, to ceph-14.2.2, I was surprised by very early crashes of both
> > > ceph-mon and ceph-osd.  After ruling out disk and memory corruption, =
I
> > > investigated a bit noticed all of them crashed during pre-main() init
> > > section processing, at an instruction not available on the Phenom X6
> > > processors that support sse4a, but not e.g. sse4.1.
> > >
> > > It turns out that much of librte is built with -march=3Dcorei7.  That=
's a
> > > little excessive, considering that x86/rte_memcpy.h would be happy
> > > enough with -msse4.1, but not with earlier sse versions that Fedora i=
s
> > > supposed to target.
> > >
> > > I understand rte_memcpy.h is meant for better performance, inlining
> > > fixed-size and known-alignment implementations of memcpy into users.
> > > Alas, that requires setting a baseline target processor, and you'll o=
nly
> > > get as efficient an implementation as what's built in.
> > >
> > > I noticed an attempt for dynamic selection, but GCC rightfully won't
> > > inline across different target flags, so we'd have to give up inlinin=
g
> > > to get better dynamic behavior.  The good news is that glibc already
> > > offers dynamic selection of memcpy implementations, so hopefully the
> > > impact of this change won't be much worse than that of enabling dynam=
ic
> > > selection, without the complications.
> > >
> > > If that's not good enough, compiling ceph with flags that enable SSE4=
.1,
> > > AVX2 or AVX512, or with a -march flag that implicitly enables them,
> > > would restore current performance, but without that, you will (with t=
he
> > > patch below) get a package that runs on a broader range of processors=
,
> > > that the base distro (through the compiler's baseline flags) chooses =
to
> > > support.  It's not nice when you install a package on a processor tha=
t's
> > > supposed to be supported and suddenly you're no longer sure it is ;-)
> > >
> > > Perhaps building a shared librte, so that one could build and install
> > > builds targeting different ISA versions, without having to rebuild al=
l
> > > of ceph, would be a reasonable way to address the better tuning of th=
ese
> > > performance-critical bits.
> > >
> > >
> > >
> > > src/spdk/dpdk:
> > >
> > > diff --git a/lib/librte_eal/common/include/arch/x86/rte_memcpy.h b/li=
b/librte_eal/common/include/arch/x86/rte_memcpy.h
> > > index 7b758094d..ce714bf02 100644
> > > --- a/lib/librte_eal/common/include/arch/x86/rte_memcpy.h
> > > +++ b/lib/librte_eal/common/include/arch/x86/rte_memcpy.h
> > > @@ -40,6 +40,16 @@ extern "C" {
> > >  static __rte_always_inline void *
> > >  rte_memcpy(void *dst, const void *src, size_t n);
> > >
> > > +#ifndef RTE_MACHINE_CPUFLAG_SSE4_1
> > > +
> > > +static __rte_always_inline void *
> > > +rte_memcpy(void *dst, const void *src, size_t n)
> > > +{
> > > +  return memcpy(dst, src, n);
> > > +}
> > > +
> > > +#else /* RTE_MACHINE_CPUFLAG_SSE4_1 */
> > > +
> > >  #ifdef RTE_MACHINE_CPUFLAG_AVX512F
> > >
> > >  #define ALIGNMENT_MASK 0x3F
> > > @@ -869,6 +879,8 @@ rte_memcpy(void *dst, const void *src, size_t n)
> > >                 return rte_memcpy_generic(dst, src, n);
> > >  }
> > >
> > > +#endif /* RTE_MACHINE_CPUFLAG_SSE4_1 */
> > > +
> > >  #ifdef __cplusplus
> > >  }
> > >  #endif
> > > diff --git a/mk/machine/default/rte.vars.mk b/mk/machine/default/rte.=
vars.mk
> > > index df08d3b03..6bf695849 100644
> > > --- a/mk/machine/default/rte.vars.mk
> > > +++ b/mk/machine/default/rte.vars.mk
> > > @@ -27,4 +27,4 @@
> > >  # CPU_LDFLAGS =3D
> > >  # CPU_ASFLAGS =3D
> > >
> > > -MACHINE_CFLAGS +=3D -march=3Dcorei7
> > > +# MACHINE_CFLAGS +=3D -march=3Dcorei7
>
>
> Hi Alexandre, thanks for the bug report and patch. the bug is tracked
> by https://tracker.ceph.com/issues/41330, and a fix is posted at
> https://github.com/ceph/ceph/pull/29728

after a second thought, i think, probably, instead of patching SPDK to
cater the needs of older machines. a better option is to disable SPDK
when building packages for testing and for our official releases. for
instance, Phenom II X6 belongs to AMD's K10 family which was launched
over a decade ago[0]. while Bobcat family is still being produced [1].

because we don't test SPDK backend in our CI/CD process. and SPDK
backend is not being actively maintained. we could just build it in
our "make check" run though.

what do you think?

--
[0] https://en.wikipedia.org/wiki/Phenom_II
[1] https://en.wikipedia.org/wiki/Bobcat_(microarchitecture)

>
> > >
> > >
> > > --
> > > Alexandre Oliva, freedom fighter  he/him   https://FSFLA.org/blogs/lx=
o
> > > Be the change, be Free!                 FSF Latin America board membe=
r
> > > GNU Toolchain Engineer                        Free Software Evangelis=
t
> > > Hay que enGNUrecerse, pero sin perder la terGNUra jam=C3=A1s - Che GN=
Uevara
> >
> >
> >
> > --
> > Cheers,
> > Brad
> > _______________________________________________
> > Dev mailing list -- dev@ceph.io
> > To unsubscribe send an email to dev-leave@ceph.io
>
>
>
> --
> Regards
> Kefu Chai



--=20
Regards
Kefu Chai
