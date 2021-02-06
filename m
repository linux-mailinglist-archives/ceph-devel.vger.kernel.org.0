Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5BD311E01
	for <lists+ceph-devel@lfdr.de>; Sat,  6 Feb 2021 15:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhBFOwM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 6 Feb 2021 09:52:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbhBFOwJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 6 Feb 2021 09:52:09 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F1AC061797
        for <ceph-devel@vger.kernel.org>; Sat,  6 Feb 2021 06:51:03 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id s5so12881981edw.8
        for <ceph-devel@vger.kernel.org>; Sat, 06 Feb 2021 06:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=sY4fgq/DSyThalwU7QX+pWYKs/8sGH7ZznMUn5qQ1EY=;
        b=YjUzJ6yC4jPKT/17YKqiPpqtCIRDhI9mebLdnj7dOHMZDHIi+JxiJAagAWt4la4SJ/
         WAUIUKcyDJPfIVPer1g7EBrXzXz9ypTzL4V5d3dhU0oJFs/x/4HjufRmNhgck1hI5M5Y
         gJHwY2DbkOYw+WmM1N2bdoYPpLEkOqfUWK2KKo6SGnkbAejppGl0b/qkHkhnSVB+LsK1
         wSEfdGZcdmxQWZwrZMmkl/KtydxTXa6j0JgIczKT0G8kiLLwbRj5BYj/Suj9BP48lQTL
         xT+yEzmPZEGtL7glGQf0ShMysI1LbGXWC01es9YnxLQ8hZ3uS7tDaGusKcYD/2NBW70V
         EuZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=sY4fgq/DSyThalwU7QX+pWYKs/8sGH7ZznMUn5qQ1EY=;
        b=UBbM6TL+D6HWJ9RMXnPkA7+VeRglJRyM3T25h9fkNr9gY/4XxZ0xkg4tEOQafMnufL
         oY2iXYKWyOHydhLnaPCpvm00FL8xXvKV85cvDorJIwwnGiiqFvQ4bwTH0NkhLjrYYDO8
         CPcek7KggvbLEI4sHaFEXl5YJZmmWSP1eaHoIJGpH8Q0RaANvlown6isX9DCvPPGNUXC
         oY9ImIHIRNmAJl2aHdEudVD+5JfPtEf+0pB9wlVRY9naEymz0ILa//cDEKBBd2Gs/kDp
         I7y9rTuWr9bvcpgI8CxrmExXHTB9vv0rgFHjaK8c2v4uGQDfxfc5yVT/hEqImHC27W2p
         PPjg==
X-Gm-Message-State: AOAM530po9KA5cVF1bagLRVbzlUtv3uDGEc5AnCJ4jyRl0j8yGgDWFJ5
        EduMsoHFdNxrXRXe4D4WJhrdblXH4uPpchGLbi8=
X-Google-Smtp-Source: ABdhPJyDo/ebENXvZstdSbBFD5YCVcSmJek6b7Gys5i5VHg1r2wQvrIFYy89vBtR0uY5z1v1Cocz1ZzUNnOFKRC/LJU=
X-Received: by 2002:a05:6402:13cd:: with SMTP id a13mr8797536edx.87.1612623062643;
 Sat, 06 Feb 2021 06:51:02 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:906:25d0:0:0:0:0 with HTTP; Sat, 6 Feb 2021 06:51:02
 -0800 (PST)
Reply-To: lawyer.nba@gmail.com
From:   Barrister Daven Bango <stephennbada9@gmail.com>
Date:   Sat, 6 Feb 2021 15:51:02 +0100
Message-ID: <CAGSHw-BWu8eXqChe=qkn2U4kPOiq-PbdfdDJ48VBJkEp+AZ8Pg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

--=20
Korisnik fonda =C4=8Destitanja, Va=C5=A1a sredstva za naknadu od 850.000,00
ameri=C4=8Dkih dolara odobrila je Me=C4=91unarodna monetarna organizacija (=
MMF)
u suradnji s (FBI) nakon mnogo istraga. =C4=8Cekamo da se obratimo za
dodatne informacije

Advokat: Daven Bango
Telefon: +22891667276
(URED MMF-a LOME TOGO)
