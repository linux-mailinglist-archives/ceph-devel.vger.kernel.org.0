Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC9695AA7
	for <lists+ceph-devel@lfdr.de>; Tue, 20 Aug 2019 11:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbfHTJI2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 20 Aug 2019 05:08:28 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:41334 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728698AbfHTJI2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 20 Aug 2019 05:08:28 -0400
Received: by mail-ot1-f65.google.com with SMTP id o101so4366881ota.8
        for <ceph-devel@vger.kernel.org>; Tue, 20 Aug 2019 02:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0HfvfW62flp7d0Bwu0WXsADzETNLrLv8hji5Fl4Csfg=;
        b=LjajaWBdaBTmgIU45wIm0a/FIq6CT1poI3t/mdkyKVHkWV2udOAR/6SzBz+7nsprxj
         cgNvgF/32t/SjGpoU3ax7oGWqVEzn1Dd3ViPMLTlzPuQbcHYMHVUAEmRddTUKHwGFygW
         25kjyA9BbKORKQ4y4vWJZ2sT4wh8fttSJarUxqt3kmQnyWGGOhAmHYmPxW29i30v2/44
         Jn7hvWw/NgX+kdlC+7ucamnQImyFe1HrpP6DnG4pRULUEKDZd1TWPlW/7tKfZJ+kPqVa
         xAuvysZjaEdXT1L5Qje6zDS7+y41qSR0yIZxVBAsol0uXE8hOGZ3AuJ1blzoKlcMBbEN
         ymVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0HfvfW62flp7d0Bwu0WXsADzETNLrLv8hji5Fl4Csfg=;
        b=hf7ILtZsv+OxQCX6Tv31IEZTB5jURRivXq3CZZLLiGvhR+SKMg+dwjDyzPlUeTNrXB
         Zv2ed5JB6cpm19s8FnRACwg1eg6ZMKSrKo2tCSnVzCi8mbFtdnWIjqp+I2GOppL0FkKM
         ur3gZ2zxIUEPeKfIz0dk9PrHt2R8mOA70cwqgkN9wExYoSpu9Pwt/GQa/lW/MJz/LIjX
         p5ms+lf2wPM89qv0U4pLR8oTcNGuwpzCV0CTOTnDOdzi+y0Md92aAeZCvtxfhpkflUEX
         8OG+9ikkCy40XarArJXskShrsgscdXI+MRigunF9j8ri77+k0MRt5vTMVL724GFEx70C
         ww4A==
X-Gm-Message-State: APjAAAXCOj6KR8X63iQMhgYsLEhaTgaWHr7XkrXdcG2C1OQQJqJaAXku
        emwvYBjVQUETQKutoM2VuXEM+ZQ+dJGVYf3mdZ4=
X-Google-Smtp-Source: APXvYqxKC0+3JxykSAL7v9QUI0lN/x8QXZJdI8fzoF7C7qS2cgkbZ0l45iphx1DvvUMc2SXmXPRDPJVSmCj/8+BKVUI=
X-Received: by 2002:a9d:7c94:: with SMTP id q20mr18837023otn.353.1566292106902;
 Tue, 20 Aug 2019 02:08:26 -0700 (PDT)
MIME-Version: 1.0
References: <ord0h3gy6w.fsf@lxoliva.fsfla.org> <CAF-wwdEsyDC=X90ECi05a3FxWwbkv-gTTZAyfnB-N=K8KgNAPw@mail.gmail.com>
 <CAJE9aOObStUp7Xqcrp6g4yOntGZ81Z7unnYJ5jBeDG=8wg=DcQ@mail.gmail.com>
 <CAJE9aOMNvOmLc9=7LLCfZTUgiyjM20vpiE8a8v9iM8CyBVJE1g@mail.gmail.com> <orblwk9xwp.fsf@lxoliva.fsfla.org>
In-Reply-To: <orblwk9xwp.fsf@lxoliva.fsfla.org>
From:   kefu chai <tchaikov@gmail.com>
Date:   Tue, 20 Aug 2019 17:08:14 +0800
Message-ID: <CAJE9aONvV+mfCDWpFdE_cZBbaa91wS2ECXoYjqQ3i1h4HQmZrg@mail.gmail.com>
Subject: Re: fix for hidden corei7 requirement in binary packages
To:     Alexandre Oliva <oliva@gnu.org>
Cc:     Brad Hubbard <bhubbard@redhat.com>,
        Tone Zhang <tone.zhang@linaro.org>,
        ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Aug 20, 2019 at 2:03 PM Alexandre Oliva <oliva@gnu.org> wrote:
>
> On Aug 19, 2019, kefu chai <tchaikov@gmail.com> wrote:
>
> > after a second thought, i think, probably, instead of patching SPDK to
> > cater the needs of older machines. a better option is to disable SPDK
> > when building packages for testing and for our official releases.
>
> I have no real clue on what role or impact disabling SPDK plays in the
> grand scheme of things, so I'm happy to defer to whoever does.  I just
> wish to keep my home ceph cluster running on those machines until I have
> good reason to replace them.  Unfortunately that's the last generation
> of x86 hardware that can run with a Free Software BIOS, and OpenPower
> isn't so much of an option for home use.  I hope retaining the ability
> to build ceph so that it runs on such old and wise ;-) machines is not a
> major problem.

not at this moment =3D)

>
> Next in my wishlist is to try to fix the issues that I'm told are
> getting in the way of ceph's running on 32-bit x86.  If anyone is
> familiar with them and could give me a brain dump to get me started,
> that would certainly be appreciated.  I don't really have 32-bit
> machines running ceph daemons, but I have often recommended ceph to
> people who'd like to run it on SBCs connected to USB storage, so I was
> quite surprised and disappointed to find out even x86 wouldn't work any
> more.  Plus, that messed up my uniform selection of packages on x86 and
> x86-64 machines with a single meta-package with all the dependencies I
> care for ;-)

i'd say it's a little bit off topic. i think we've fixed a bunch of
issues[0] related to armhf. and i managed to build ceph in a chroot
env for building armhf binaries. so i assume that Ceph does (or did)
build on certain 32bit platforms at least. but since we don't test
and/or build on 32bit platforms, this could change over the time. if
you are able to pinpoint an FTBFS issue or bug while using Ceph on 32
bit platforms. i can take a look at it.

---
[0] for instance, https://github.com/ceph/ceph/pull/25729
>
> --
> Alexandre Oliva, freedom fighter  he/him   https://FSFLA.org/blogs/lxo
> Be the change, be Free!                 FSF Latin America board member
> GNU Toolchain Engineer                        Free Software Evangelist
> Hay que enGNUrecerse, pero sin perder la terGNUra jam=C3=A1s - Che GNUeva=
ra



--=20
Regards
Kefu Chai
