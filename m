Return-Path: <ceph-devel+bounces-3316-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E0F8B03E74
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Jul 2025 14:16:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1A523A5681
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Jul 2025 12:16:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB297225771;
	Mon, 14 Jul 2025 12:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GOfG1zyX"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372EA80B
	for <ceph-devel@vger.kernel.org>; Mon, 14 Jul 2025 12:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752495404; cv=none; b=US4pr0cfzdmVsp5o74/smtCPHCGV/wtgwZJylOq7XwVitojZJ3pubKYaU2S+kJYtROBtI5JscqT96thsj0zz+EDizgeekca1iXnw484KXztRQWEmlSMHVzzw+7i2cRvLxj6rIu1M5cTh/t3iC24FM/myMqxt2PYz59KaCHiIdd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752495404; c=relaxed/simple;
	bh=el5XaZ2rGIvmgMOFPU8QbMsgOiiQmNWjEdOZocxY7Vs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r15Wley9wAiTpcnh8KiQmiTEL34vcfRnavMwAeXpFMImatp0JS1ao9wiWqOGX5JizhW4lSjFWiIwzlRubgrkGM1I344WkJaCSBtGJqPuULWm58p3wjbhS3FFeSWk/RYnO3UiyTiiCVFX3xkOGxwBzv1f0dt+s5vxAkbObt7USXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GOfG1zyX; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-235ef62066eso61988635ad.3
        for <ceph-devel@vger.kernel.org>; Mon, 14 Jul 2025 05:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752495402; x=1753100202; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m7B8Hv4R46eni5f7pKNZna5OHUjLDX5iooYTIyemTCA=;
        b=GOfG1zyXT6xeuljOfCT/3wfmY3RAKqUI5MBL4uThOczzWi2ROO3rRUnBmKynMAtOZI
         78KZifiDXqtMj9vy15yp+iZpWKwI3b4lkXeFeXTKnTPW3GxahCj09MT0lnN9EsYK3JDD
         QcGGwkpv6zkVzzba/JeQkgmRoTT35CTImP2P5d54ofRbLPZ63mPPZ3JKPdQSs/+lHSKH
         jtYJw/JaKq2+dQui86PLzCwh3PwjPxopaqvm6FhME7u4Qcp6kptlX7QvSTCEV8Apv8m0
         Y1lBueDiSTwZRwbTLgKwkIVN0xH2xiQ7Cg94qPFPT3s1OSio9QMhQ27VBajO5P5/biAa
         xNKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752495402; x=1753100202;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m7B8Hv4R46eni5f7pKNZna5OHUjLDX5iooYTIyemTCA=;
        b=CgINxnGp+QRK4PfAFqWA6Q5s58alSCS7B4OyqfnG4QYOlpghAmXgn5ovbXuZSNKG1A
         w9ceiEfreqC9XOr2m74VGboYmqTbl9jYl5N8MsEB5eBEwOTftnZUjAabcLyPfWo1Te22
         rmZjqfQYf+cVon7+6U4EQl4xO5k58eh66D5+Nh4CnJFkVBWU+f0wIRu7WsMzykgwwEIh
         tiIxbg0tIZoQjw+66+NBWLECb8SRk5YJymZNMczmZgseAP+7IYgaOFxegtMvGuug8FV1
         b6m3dsV+OOgW/YX8juBPWFHvrwYV+Nrv32mPIcwZ0Ul/tGeilYFj2GPrf2HlU1RysUpS
         CbwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXORJ8q60QWkf8VqkPxRGbrCvG91IgtIn9zgB58prbxGJKcph/2u5DpEy1IdZWVUXYi6emAcG6IRGSz@vger.kernel.org
X-Gm-Message-State: AOJu0YyeHVNN6qr7u8nRsu46Cs9WtUH8/L67y18WgWIlaCBpdpREEB3F
	eVF3i0y+lamIQbRgxZvh7448AOmFTR4x1WzEHFh465wAFJUjSwug60BSmsg73m8uImLJpCzxwEO
	tdNvPihQj1yrb7rLNQf6/Q4ux0pa2/iM=
X-Gm-Gg: ASbGncsnHRI5w8Yt34ELRqNvMsRXulBE8gVjnqjH/bcQhZhVwaVGF0mmt3roP7zc2Uk
	/bi/iPzpmukD7KS7bWDiEYb/ut+Q3iuBFaAghagPX7iuFVKf7mNJ3eCRMae83F895fmaMtu40BI
	20qAGWwAeC5ND/UfIZo7p8/03ThoNI+Oqu0KQXjjlj739uDz7wtqJ8SqYGCTAwhqUU/Q/FFeQkA
	4XvAcg=
X-Google-Smtp-Source: AGHT+IEJ3/lhJM8Vw5rEMOFh1wdwUGgMQ2szlufd2Zj0D7qhsEHXROcsn17HaD3dPg7kRFlAJtE7yngh8xQoUxkrsZ8=
X-Received: by 2002:a17:90b:5645:b0:313:1e60:584d with SMTP id
 98e67ed59e1d1-31c4ca84addmr19502885a91.11.1752495402261; Mon, 14 Jul 2025
 05:16:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMym5wv+R8Wu8-jXkEX9fN7tgKzh_SjpPnDkbKFwjgUfjw83+w@mail.gmail.com>
 <4DFDAA8E-98D2-461D-A5B1-05C482D235A7@dreamsnake.net> <bbb5efeac49870dad9783e30df1d37c6fd949172.camel@ibm.com>
 <CAOi1vP_a2s0Q+tjFdLAfU+Tzut+HTCRfkteQyr3NHG6rQbvm=g@mail.gmail.com>
In-Reply-To: <CAOi1vP_a2s0Q+tjFdLAfU+Tzut+HTCRfkteQyr3NHG6rQbvm=g@mail.gmail.com>
From: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Date: Mon, 14 Jul 2025 21:16:30 +0900
X-Gm-Features: Ac12FXwqCA-ouNX4_CkzcdJxf7GaxR8VJiA38ITj3NN--_ZJMiDcYlc8tKq9XqE
Message-ID: <CAMym5wu4gqAW+-sG9qrcOuYQL95atU8rvZNNY2G1hAqpjfqJPQ@mail.gmail.com>
Subject: Re: discarding an rbd device results in partial zero-filling without
 any errors
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>, "aad@dreamsnake.net" <aad@dreamsnake.net>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you all!

Now I understood my expectation was wrong. My goal is to erase the
existing filesystem's data on RBD.
I'll use `blkdiscard -z` or `ioctl(BLKZEROOUT)`.

# To Anthony:

> My sense is that blkdiscard is intended for something different from what=
 you=E2=80=99re intending.

I understood, thanks. I thought discard implies zero-filling.

> Was there a mounted filesystem when you ran the below?

Yes, there was a filesystem. My goal was to zero-out its data.

# To Slava:

> Could you confirm that it worked as you "expect" before 6.6.95? Otherwise=
, it's not the issue or bug.

I just tried that commands in 6.6.95 and my expectation was wrong as
described before.
So the behavior that I reported isn't a bug.

# To Ilya:

> This isn't really specific to RBD.  If you want to efficiently zero
a given range, use BLKZEROOUT (pass -z to blkdiscard command).

Thank you for letting me know. I'll use it. I verified it's far faster
than filling zeroes by `dd`.

Best,
Satoru

