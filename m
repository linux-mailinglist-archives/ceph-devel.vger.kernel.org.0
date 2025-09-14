Return-Path: <ceph-devel+bounces-3608-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75DD7B56C08
	for <lists+ceph-devel@lfdr.de>; Sun, 14 Sep 2025 22:12:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D890176776
	for <lists+ceph-devel@lfdr.de>; Sun, 14 Sep 2025 20:12:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E27F2E1C6B;
	Sun, 14 Sep 2025 20:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J+bWrz7t"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5D61D90C8
	for <ceph-devel@vger.kernel.org>; Sun, 14 Sep 2025 20:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757880768; cv=none; b=A6DDhUM5lA17lL8CjE5dcbWScOMvSZby2eXVrBc/c3TcPg110EN01TRBq/GUbyRv3zfcyrR3plhxNGd7Zpbbd6siU0bz9mbbnCOfFCQgxTuueLuKj7yfjOEMYyaO1cvxXZeACDJXbNWkQOwOnyn9cEC4syMNZcJPNb8mJzcgRT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757880768; c=relaxed/simple;
	bh=MpdcxKG+UbZqIw0GvjG+L5N0umhnX6wNZOYSgjSs9hA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HTEzkemitfCwSf7Of8fNHTVd8pgP7/F14R0T1TRoMMozxyjJQ0zzwMisEoGH8tWRm51DS71e47VH6DmkxvJAta9Mmmr3eJYI+rGy/q7SMT8RmkaNc9q5isXW6P3t0El1z25MpRgYOr8bUuJA3ufyl854md0oTISa5rMZQtRjTCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J+bWrz7t; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45f29d2357aso5997295e9.2
        for <ceph-devel@vger.kernel.org>; Sun, 14 Sep 2025 13:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757880765; x=1758485565; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NOD2tP/vP2x3pAfsfoPV8AWujNxWo1YU4mET3dIG8zk=;
        b=J+bWrz7tz81HwLABta/jc4yOygmGPLdyUkHac35lottJRAvn9eUk/taRetLeLcHfDI
         KwHEGezXagWTqjH2XZ6EpXykKx2uSUFtkZE/fRQwwE711rRKr+hkyO/GLhrZgeaNyko0
         2kyakZOvZDTywfCTwEw6zzUrruujEwqtRJDXlDUrdgOsTqEBqSbbhnkbhWmkidSk4M+E
         kDiNBHHIXhPlOXIRyJuZDTiduNFuTP14YPqH4cwvkYoiMbeGv4/A6hpoJGWkyc8AH59Z
         jfB5AYieqrajlwSWlX/tIPqSo3P1uoO2eTLIWwAeYGlGn50odKnX8jIYIWlpqMaYHdmt
         92ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757880765; x=1758485565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NOD2tP/vP2x3pAfsfoPV8AWujNxWo1YU4mET3dIG8zk=;
        b=YYJflR2UAImrbzzKQDAf2i0tOBc9NA8oKj6u373rxseEqcLh3i0suArT+pqx8JZ0Dc
         H92nnwo1UQ3tCpIz2PePy8akXXY0X4NpFvQycLCu1Jzz7waqZkGVZyx0lAkHzVbqi2MX
         bqTkLhyNrEx/Jntv+KoZeUVXMZYMiC717nlugp2izB+qYlD9Eh9Bg3YOIzh5TWadeXVB
         bVxshXFqkUq3vZ4mVWj90GdY0xCdw4vrY6F8OP/k6rhTTRWgVdMSFW64NCTbI7+dUwyf
         IFFHa+cLyHUSPlhIjIOQ/0y1LV+mGVl9vLaGXGubPjEZmEyq668xHyWPnYbAYsg2msZK
         ypcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVZuGAPfqF4bouG9NZ32GCjNrk8Z5FZvBpdgnoZcJwf0AYd3kxq0Zs9bGK+JtHBh1hLqOgCqxfbWmS@vger.kernel.org
X-Gm-Message-State: AOJu0YxccHntYC71yqMpqeqNeplo5bEXTPqGtMrWud8dZL14kx6eAM0B
	XTiGfBNC05UEtzydHMbsY/jStcLKEyeAs6hLEiKdLanfq3LLjp32cZbT
X-Gm-Gg: ASbGncsHEbytMXZIzzu9YO08A0M8jOVzQWzQXfLuWIZnXTdCk163RE0dZ3ihspU7CIL
	18dyQAupG7AuwvzCxdCbyu8t/ELNhNxx+JrLNrugrt8/BHBhNgLJVosRSfj1AeSP6HpJ9hveFoM
	9xPwdrEWfWO7TNN/k85eOP4o9PdDp4hF5jk0oDi9nmtsXnwvPZfjR13QGynfs8AIiA1xugshsGE
	BrsOpDn+RiPUQ5K0/oBtkTLWQlwkQrIkroau7BxB9jXfxs5qyANDOHwhde/3LMfHNS8Rd/5vrru
	7G7AazJi4ollh7xAdnxlFxbPNuuVCdV5dWJJEty0Rsb4h3zCwPVFDsOOQ/FF+C78iY/QAiUZKOB
	j8QvgYQEKSGVc18PRZ6HLDZFrh9d808luHYVDAz/onUcMcNDcHEveTw46n0INPkTV5N3P35o=
X-Google-Smtp-Source: AGHT+IF07rnJES394otwTHwQbpN7fZiWm34So3i+hi8c629sbgG+ujHq7Z2rRTWlSTbUV7JHiRGVaQ==
X-Received: by 2002:a7b:ce91:0:b0:45b:7185:9e5 with SMTP id 5b1f17b1804b1-45f211cb910mr79757535e9.5.1757880764849;
        Sun, 14 Sep 2025 13:12:44 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ea9abd7234sm1688593f8f.59.2025.09.14.13.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Sep 2025 13:12:44 -0700 (PDT)
Date: Sun, 14 Sep 2025 21:12:43 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>, Guan-Chun Wu
 <409411716@gms.tku.edu.tw>, akpm@linux-foundation.org, axboe@kernel.dk,
 ceph-devel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
 home7438072@gmail.com, idryomov@gmail.com, jaegeuk@kernel.org,
 kbusch@kernel.org, linux-fscrypt@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 sagi@grimberg.me, tytso@mit.edu, xiubli@redhat.com
Subject: Re: [PATCH v2 1/5] lib/base64: Replace strchr() for better
 performance
Message-ID: <20250914211243.74bdee2a@pumpkin>
In-Reply-To: <aML6/BuXLf4s/XYX@visitorckw-System-Product-Name>
References: <20250911072925.547163-1-409411716@gms.tku.edu.tw>
	<20250911073204.574742-1-409411716@gms.tku.edu.tw>
	<CADUfDZqe2x+xaqs6M_BZm3nR=Ahu-quKbFNmKCv2QFb39qAYXg@mail.gmail.com>
	<aML4FLHPvjELZR4W@visitorckw-System-Product-Name>
	<aML6/BuXLf4s/XYX@visitorckw-System-Product-Name>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 Sep 2025 00:38:20 +0800
Kuan-Wei Chiu <visitorckw@gmail.com> wrote:

... 
> Or I just realized that since different base64 tables only differ in the
> last two characters, we could allocate a 256 entry reverse table inside
> the base64 function and set the mapping for those two characters. That
> way, users wouldn't need to pass in a reverse table. The downside is that
> this would significantly increase the function's stack size.

How many different variants are there?
IIRC there are only are two common ones.
(and it might not matter is the decoder accepted both sets since I'm
pretty sure the issue is that '/' can't be used because it has already
been treated as a separator.)

Since the code only has to handle in-kernel users - which presumably
use a fixed table for each call site, they only need to pass in
an identifier for the table.
That would mean they can use the same identifier for encode and decode,
and the tables themselves wouldn't be replicated and would be part of
the implementation.

	David

