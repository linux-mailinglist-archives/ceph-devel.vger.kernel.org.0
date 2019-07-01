Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4B95C175
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jul 2019 18:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbfGAQvW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 12:51:22 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:38239 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbfGAQvW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jul 2019 12:51:22 -0400
Received: by mail-ot1-f68.google.com with SMTP id d17so265553oth.5
        for <ceph-devel@vger.kernel.org>; Mon, 01 Jul 2019 09:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fMfoWNzuJNqr8PO17XpdExoxuaOFNpFtZrHvFK2LXMk=;
        b=nCdlox6gplG9FvBUgR9BURuMOCjjkFy57eSdZkZfTNDNnDoth8yPgLjF62TZSbctga
         WJUGUoBJcZtg/E7cVfhBZ+RlQqv1Rn3AsIjZ6JDyeHsiKrtzUOGXG7wfaNfOAwHrNzT6
         7Rh+qnR1r4Dn3YMhmC4RIsOp+/PPBOYVe06iBMAhiLGyX12Q1aQN/i6c9Zm+HP+n2rHV
         8n1ms5CzA1+PmQje5nBJQD7TWNtrPEKEDsqK8X730HeK6uTdQOHjK+KN3n/wTnZnWhCd
         qgEjiyCNewzy8faEyLTzOPcf0zYRbZ0sNT0wICPGmysOU3Gk26jfQI5qnHsr+q2mA+T+
         eFng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fMfoWNzuJNqr8PO17XpdExoxuaOFNpFtZrHvFK2LXMk=;
        b=gtTiYhyvcNnTCqxgjHhcluH0Y7qHvR+SeMXlg9IJ+QJ3jJhAccv35w4HndMZ0q1tVr
         UwADsthILQOLtJHz1F7X6U4/akiGC5zcceScYChmWwrUg4RxoveYuNdOL5sSCHWTODpT
         kMaGe2anRl//zEUIZG477bJwGNKsj4IitLDPZFKdhYZ3F4OWhr7/JdiLYHlx8QETTPVp
         II5IEcYMouOqfmUVGRQzZ/KCvIWtO0OpON3vXvW4HClOJfDF6/zA/vXVhHHskNF+JyNr
         DRElIlksegV2kFJUZj10OVetfL2xTe9DRpaseG1x8hmFDQ8q6p38JUX0xFqC5Q/qjLT7
         8hJQ==
X-Gm-Message-State: APjAAAUEghqMCVaXEButHF2hBjfKE+lPkWEhgm7NStt3YUb2t7cVsfcz
        RHeWcNf1aZ/FhcMrEknHAbfMhbUGdWiPO6mag2I=
X-Google-Smtp-Source: APXvYqxic6/Dsg3+VXz89XOd+m01/XpauBIOrNvxEi1iliyFrxJ0rg2NUV5MlKENE57Tbi4CZ0FYRW8wfE1r0kCzep8=
X-Received: by 2002:a9d:735a:: with SMTP id l26mr21840593otk.105.1561999881362;
 Mon, 01 Jul 2019 09:51:21 -0700 (PDT)
MIME-Version: 1.0
References: <CABAwU-btvFQypUTwjgGfS0L2iPdzOBdKFUYSLK_TY-_Sq+96Dw@mail.gmail.com>
In-Reply-To: <CABAwU-btvFQypUTwjgGfS0L2iPdzOBdKFUYSLK_TY-_Sq+96Dw@mail.gmail.com>
From:   kefu chai <tchaikov@gmail.com>
Date:   Tue, 2 Jul 2019 00:51:09 +0800
Message-ID: <CAJE9aOOTZbM8GE=_2BckrcLiZ5inG=LSb4Cr0Saw=H0y51fH8A@mail.gmail.com>
Subject: Re: how to do cross compile ceph to aarch64 on x86
To:     huang jun <hjwsm1989@gmail.com>
Cc:     dev@ceph.io, ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jul 2, 2019 at 12:21 AM huang jun <hjwsm1989@gmail.com> wrote:
>
> Hi, all
> I'm bit curious whether ceph support cross compile to aarch64 on x86,

actually, i don't think ceph is different from other softwares in this
perspective. so if you know how to crossbuild software xyz, then the
same applies to Ceph.

> any documents introduce about this?

IMHO, strictly speaking, this is not in the scope of ceph-devel. but
anyway, first of all, you need to ready the toolchain, and then
prepare a toolchain.cmake. and then, just use cmake do build Ceph. see
https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html#cross-compiling
.

or, you could just use sbuild or some other tools to do this.

> _______________________________________________
> Dev mailing list -- dev@ceph.io
> To unsubscribe send an email to dev-leave@ceph.io



-- 
Regards
Kefu Chai
