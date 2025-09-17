Return-Path: <ceph-devel+bounces-3669-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 45C50B81ED7
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 23:20:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8BBB188DD70
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 21:21:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5D5A2F39D0;
	Wed, 17 Sep 2025 21:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RcQgbOt4"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020F82749CE
	for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 21:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758144046; cv=none; b=jVrqBnKAuK61kxZAaY5o2wQ6zcwdP0D6CIWT2K88H889MLqVx1MN/+wvpMJYMOnjrR+H2H4nuyL8XIINqgse8qXfewaqB/lMm3w0WwWAupYi2jd+08SE7kwwLInbVBnPrs5p5SCBw1VoCfCEVoo3yyQGnI8TixQ+L6S4FXqDMz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758144046; c=relaxed/simple;
	bh=Jr7tOhVNmdopvbm1sq/HNYW2sZzQ2S6zGCTPL3CWNug=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p69w/UY/lNRr1cnPO3vXgql/B0Br7T/LEyDG6McNMsthm/RbmIPPGAkbYhXxx+6v78VSr1pgRn50Yh5vsHKfccY3vTozfr8DXCOEG1/3ZlgtcUqrLEIoOFhHXrQlhAOsPRYRjXuCEHb1ovR+grjhHebeNFxxXich0oW0WUpoTIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RcQgbOt4; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-62f1987d44aso340433a12.0
        for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 14:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758144043; x=1758748843; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qm04iO7/3sYnnmFBSTq3Jy38SggYiX1vAG/ti9DkIJ8=;
        b=RcQgbOt4lTo/tMBQB/CZS1bMg/5QbiabDAVtWYoM6jOZM2syjql4x6o5Op6oFjZsVx
         u/tx9EVOW6uywVPTQPZV7wrYvGMS8ZozcHFEq6ZSDUojv3+UPmkf/ajmibbEZkPV8TLe
         TtdonGylex26e78pDhnT+24/Z+1HS4ywAh2qNKaiHXzo1MBtdfhhuIkdYsavx6n9lSk+
         SJ40FUN9LaK2/pLd3MoHcqiKF8eiQlLnrjsU+dJBc61QKyuA1bP2gI58G5puEmz0XGNp
         zNqX2ip2pWjDB+ZsYBxy35XuXdcjZK22bIC0/umW0b/Sy5S11+IZr7vZLaF1u9alZfdL
         L/iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758144043; x=1758748843;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qm04iO7/3sYnnmFBSTq3Jy38SggYiX1vAG/ti9DkIJ8=;
        b=BPjXOVyqSkopk2KSgjpcoAyy64loNohG8HG8yfbDpuHF/UiJd8GDhuODoDRRn4E5gH
         dX6AOPy+bmANdmgUSvPpgzFAY8nJ7hEJAS9iS22bnmuT8K5iLVxE3IQR0srN3WytOwvA
         6UgqzGE8tZh+B427tV1cSWmLX9PZspEmqa3C3qIGqDLyaIU63aEoO9szAPY4Xg7pDUU+
         ndplJyZyv1CT17gT2gtDA4auE9g+Yv/MH3bllYQdLRmcHq4KZN1Agwb0wvBjgeWBoi0T
         frGfaDJn7PalxRdPEj4UatHETt0wVDGkyIYd9NIpdKPuwta1Wq9DwBsB3EZGCmvOOzG9
         khuA==
X-Forwarded-Encrypted: i=1; AJvYcCWxaVrAN82y9h6WHiM+IkpsOj3HHrK/kVQroEIgQU/IJ5PPCVlWhgK5VS4esC8ZL9k3kkhWDiYBsgoY@vger.kernel.org
X-Gm-Message-State: AOJu0YzZyjsnSj3PEUvAdj6UUC1fQoJzYYQZ+iMI9IDLocore4nMMLfM
	S15vY7iHNqYiew12WijfEwPaxnwW5nppcFaYifASTBXzS/+XO1TjezMvojL1gmDit8Dgh1hG3ot
	X8YpoauIagW6fl2Kw4umVLsv908nJgnY=
X-Gm-Gg: ASbGnctt0gqW1AX59X3F3OMTI5o5FAUZ09Zq96WCCEL3Z6R5py9J0ZgVDwitGrAJYYc
	Ese3p9Ndi+EUGtTwGkGUj8mli79H+3lGRQTfk130EhABipYrn86oGVD6MEpSkjcxC6xjvLPH8nc
	rNYyauivQwulevLoxPf2M+r9sfMJ/Uhu1M1l7bdgfDoyAQoUNyeVVrN+t1cpNeIyO2nBqLTezOB
	JzbXuGn/icJRXlztme0LFC112/Wu5bhCeMsLK6OU1Wx23Eq+derP70E3Q==
X-Google-Smtp-Source: AGHT+IHUs74RiuzMxtMB/SJNv66S3T8Y+4J7/v/JeOClSkPet/FUx/BcGD0yy1WcahJITTBzZkWaZvd3zcPgO7Lq5J0=
X-Received: by 2002:a05:6402:5211:b0:629:3f9d:b06c with SMTP id
 4fb4d7f45d1cf-62f84444eb5mr3183454a12.33.1758144043263; Wed, 17 Sep 2025
 14:20:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
 <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com>
 <20250917201408.GX39973@ZenIV> <CAGudoHFEE4nS_cWuc3xjmP=OaQSXMCg0eBrKCBHc3tf104er3A@mail.gmail.com>
 <20250917203435.GA39973@ZenIV> <CAKPOu+8wLezQY05ZLSd4P2OySe7qqE7CTHzYG6pobpt=xV--Jg@mail.gmail.com>
 <20250917211009.GE39973@ZenIV> <CAKPOu+-yOH6yzPEw1rayR1thO0OdPYCRL-CWkRTp9YFuHuRr9A@mail.gmail.com>
In-Reply-To: <CAKPOu+-yOH6yzPEw1rayR1thO0OdPYCRL-CWkRTp9YFuHuRr9A@mail.gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 17 Sep 2025 23:20:31 +0200
X-Gm-Features: AS18NWD_v5OF_xdeJXUDk_UQNpV1LRyG_6pKAZAV2UR008iFDMbWoAW5oKUSiLo
Message-ID: <CAGudoHFdbmrLfLNKRb4cauzHOPBDqQT1zJ4xYCLXW5RJViwmZA@mail.gmail.com>
Subject: Re: Need advice with iput() deadlock during writeback
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 11:19=E2=80=AFPM Max Kellermann
<max.kellermann@ionos.com> wrote:
>
> On Wed, Sep 17, 2025 at 11:10=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk=
> wrote:
> > > Each filesystem (struct ceph_fs_client) has its own inode_wq.
> >
> > Yes, but
> >          if (llist_add(&ci->async_llist, &delayed_ceph_iput_list))
> >                  schedule_delayed_work(&delayed_ceph_iput_work, 1);
> > won't have anything to do with that.
>
> Mateusz did not mention that the list must be flushed on umount, but
> that's what "incomplete sketch" means.
>
> (The patch I submitted uses inode_wq, but that's a different thread.)

I assumed someone would flush it to speed up the unmount.

I fully admit I did not realize it was a correctness issue here (see
my other mail).

