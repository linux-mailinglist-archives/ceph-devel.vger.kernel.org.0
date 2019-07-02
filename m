Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD655C692
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Jul 2019 03:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfGBB0d (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 21:26:33 -0400
Received: from mail-qk1-f170.google.com ([209.85.222.170]:35529 "EHLO
        mail-qk1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbfGBB0d (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jul 2019 21:26:33 -0400
Received: by mail-qk1-f170.google.com with SMTP id l128so12677215qke.2
        for <ceph-devel@vger.kernel.org>; Mon, 01 Jul 2019 18:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EGcqcvyULoziQNIwona+UhvfcWphJFHF2je74a4tzD4=;
        b=HhJ7az8F60Wn9r6sFA2M3QYLGjEe+zSpZDiX2hM7gQ03NrSoYElfScrUkbnWWDcMbX
         nJgVXOXs86tIm8vQ4qc03wZDE6HEWx7Eb2G8ME6QqdFxnDFQywkvbiu/sTlK+VLh5b7J
         OIaq7dbTnnPfSTSS5A7tg9DYs3rjzznWOTyQaIjhcIGU2XZQW3sDEADZyz5gj4tsxZ/3
         M/e7aVfR8HSfRLV/nQ5jSzuhz30X9Qx/ozSZtUbvCf7zhSKbwZdtfUoj9gf9T8Z/9pG+
         5iH7qW+xvajc1VmRG1B9jwkpPU3nJJhXz22AY1v/7aQXT8GSc7fXO1k0F+cW4aMzo3Bd
         qObQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EGcqcvyULoziQNIwona+UhvfcWphJFHF2je74a4tzD4=;
        b=UvwotKwP97Vca2gxvC00SjQOQmIFBVx9l9DN/P1ucYeT8MehsQEnoi0Ct1ngQNPpJl
         nveYuKXPDa47TDDyrw4fBeZDk70B73Zj5tzjK+uG6HymCTvz+LDNUWUZWmWV1WgZV7pW
         WkMX1yp/jDPuKPhWrgSd8MNdsy7IK0jRQo8IjUEOJawBebxGb1LcCSzH9hl9R2i0uCMv
         HR4W/1cMOP+VjhSBNT7yzUfGZ1c4Rm48ylsIR5txGk8It8kWGcvmnqT+TgkehGKw+7aq
         XgLyQ9XNE77iK0GrcJZ2AwYGtBqVCc0wF0bhAtiVADX4tmSs4XLOYkOTmbqVmuouhBNq
         ZzTA==
X-Gm-Message-State: APjAAAX8Tai49hUFRuzu9Zsl1vymMgxYa64qZp77sR7FFMGE/Y/1Ryne
        bOiAy9vEdKKoVv8f9EHlnJbjfkT3O6I/lU4HKxnAEw==
X-Google-Smtp-Source: APXvYqwgRgWGEsxtqGuNS7h8uicpJH+sD7q6Vc40B3YkIJH5SV7pro3xSgByFcOhF+1oIcg39bb1RUfRUuEEi6M9GZ8=
X-Received: by 2002:a37:6dc7:: with SMTP id i190mr21499392qkc.489.1562030791834;
 Mon, 01 Jul 2019 18:26:31 -0700 (PDT)
MIME-Version: 1.0
References: <CABAwU-btvFQypUTwjgGfS0L2iPdzOBdKFUYSLK_TY-_Sq+96Dw@mail.gmail.com>
 <CAJE9aOOTZbM8GE=_2BckrcLiZ5inG=LSb4Cr0Saw=H0y51fH8A@mail.gmail.com>
In-Reply-To: <CAJE9aOOTZbM8GE=_2BckrcLiZ5inG=LSb4Cr0Saw=H0y51fH8A@mail.gmail.com>
From:   huang jun <hjwsm1989@gmail.com>
Date:   Tue, 2 Jul 2019 09:26:20 +0800
Message-ID: <CABAwU-bF4pP8bMt=RaoUoUfvJaXiwJAyoea9X5_qVZNNK1udKg@mail.gmail.com>
Subject: Re: how to do cross compile ceph to aarch64 on x86
To:     kefu chai <tchaikov@gmail.com>
Cc:     dev@ceph.io, ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Thanks kefu, i will try to get toolchain ready first.

kefu chai <tchaikov@gmail.com> =E4=BA=8E2019=E5=B9=B47=E6=9C=882=E6=97=A5=
=E5=91=A8=E4=BA=8C =E4=B8=8A=E5=8D=8812:51=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue, Jul 2, 2019 at 12:21 AM huang jun <hjwsm1989@gmail.com> wrote:
> >
> > Hi, all
> > I'm bit curious whether ceph support cross compile to aarch64 on x86,
>
> actually, i don't think ceph is different from other softwares in this
> perspective. so if you know how to crossbuild software xyz, then the
> same applies to Ceph.
>
> > any documents introduce about this?
>
> IMHO, strictly speaking, this is not in the scope of ceph-devel. but
> anyway, first of all, you need to ready the toolchain, and then
> prepare a toolchain.cmake. and then, just use cmake do build Ceph. see
> https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html#cross-=
compiling
> .
>
> or, you could just use sbuild or some other tools to do this.
>
> > _______________________________________________
> > Dev mailing list -- dev@ceph.io
> > To unsubscribe send an email to dev-leave@ceph.io
>
>
>
> --
> Regards
> Kefu Chai
