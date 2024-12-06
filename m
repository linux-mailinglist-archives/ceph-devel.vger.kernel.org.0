Return-Path: <ceph-devel+bounces-2267-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F7159E7BEB
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Dec 2024 23:48:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F3DF280CE5
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Dec 2024 22:48:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BA851F4706;
	Fri,  6 Dec 2024 22:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="JJGj4uFb"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974BB22C6D9
	for <ceph-devel@vger.kernel.org>; Fri,  6 Dec 2024 22:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733525307; cv=none; b=ucf0YPTNrZuOO2cfGDwEQ+TJakZJ29Rq7xQpDBhesCkygH/5NjQ2lIYmonz6my265M6nhw+3S+LJeI+/FE5/yafkMTWlwf7OBOyMCb9vgiH7f8Lgix7sbamV8bkrQzBcMxxs5wPz6WFoLPbvg6hSilJBZIOz9NN7y2rzMxyykCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733525307; c=relaxed/simple;
	bh=1BWvsmk3F4Oxl/qJ24Ok5zN6PmBHW1QeWrGkfyajj0E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r+s9Us5dqTHiQP5aOEIowUp1pLLDoD7MprgwPGPmKyUhEePgCdAkxcPV9cd+UNhWTFDkiuZEtE/YKxY9LThCHQ9IjlepzKHfc7PMuEF8vohmFAuBzALyeYGg36qxU6NfS/QykaLhjsqOhoJMnxA4GD2Wx+AB1QfiX61+roSeUpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=JJGj4uFb; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aa549f2fa32so482693766b.0
        for <ceph-devel@vger.kernel.org>; Fri, 06 Dec 2024 14:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1733525303; x=1734130103; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1BWvsmk3F4Oxl/qJ24Ok5zN6PmBHW1QeWrGkfyajj0E=;
        b=JJGj4uFbUHGgGycQgZA9MfSjeBl8wbk/EO5JIlLi1oZ1x/saeCc0lvAsZRCEWv6ObU
         XXwbWzK4hP+9Kwbk7n53vhq6/dXaeHNj0s3XqEgAZNRR8pWQGjevK3RQ87gW6OmAzLe6
         8uO01UlusmWBD1S5KJnldikqEi1A2pYDHdaFqrV6JotfBrCIxPJjidoN5aFyzE4TmOdw
         ZLELY8WEE2zcUFeyHzU+BHoEkJnCcRjwxiBiEmVZpuF3eM39LdniJQRf2C3VS9mSK3vF
         cee8gkUAnX1BunfDHWGVlzgK5f6WxclQSYMXt83eLPln4IpR/kwPESSBbTUWLzVrmoSR
         1a7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733525303; x=1734130103;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1BWvsmk3F4Oxl/qJ24Ok5zN6PmBHW1QeWrGkfyajj0E=;
        b=g8TdLtpCpB7ILeGHXEYMposseYVgb6osY52LFxdcqxwK5rsyh+3tzSBevY5v0gVSi2
         mn/bltEd3x9pdHCp0DZxRz3UxczcW/PPDmzdopAr5HNmczRT+x79g/6+tgpboZZNFMhQ
         UxPyy3agWrhLUGBoIX0b4A8MA0uhDNP46wjAsXEcbfeL5GxuyckCFCZ6ZPlm9KpuDDPg
         2hlowrYV7CnOCGmsqb+7kd2Jwvc/az9BAVRTcWhIaISne+jU7fJu4oWq/fDXceQ965hx
         R9oI0PKk4N3+WVDyo8LgPUEdfOAlF+VyhrWvAqyBp7DT5PQlnXN8zfwbf8n5Yxa5oRAA
         uerA==
X-Forwarded-Encrypted: i=1; AJvYcCVAGmWI9uEZdkYU8FjrrOF0iu5lvzgqABcy4olhnJ1aPm92gRrYWV+LVeRQz8r0gB4U0WqptOXEZQmY@vger.kernel.org
X-Gm-Message-State: AOJu0YzqPP7SHW6GarFGMEQs2INOnWd5dzMcZ93NFDPdpiZ3AmZQFQtA
	P8J1aOcqWEYumjVe793VQcfE7LV51GRsA5yTSTTX7nSKAOobG0lOp9CyVO6UGl32pwZrDpevi+/
	ZMrFVqLpLkNt5Y/ud3IpAFAwhEp00roAeDOWL+Q==
X-Gm-Gg: ASbGncvNiB0/YpN1Fntx7NPWqWlAjf6+nDOahKSy02a4QFZMh3igBe91BGlwmPYKW0D
	XW6TAqX/hrf96TMU6omMzgLe7/XCXpuDqrJl7uq0NRc5LiJYwAeukkVsAGw0w
X-Google-Smtp-Source: AGHT+IFk7vAYpJ4ej4R2TYQ+KRfQ97bzd69cRG0vYtoOVc551gTh5/P+Xso9NEyVG9xovJ8bKaK2d9k4saRpRapGZhI=
X-Received: by 2002:a17:907:7701:b0:aa6:302b:21e4 with SMTP id
 a640c23a62f3a-aa63a025c44mr453223266b.16.1733525302996; Fri, 06 Dec 2024
 14:48:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241206165014.165614-1-max.kellermann@ionos.com>
 <d3a588b67c3b1c52a759c59c19685ab8fcd59258.camel@ibm.com> <CAKPOu+-6SfZWQTazTP_0ipnd=S0ONx8vxe070wYgakB-g_igDg@mail.gmail.com>
 <cd3c88aae12ad392f815c15bab0d54c8f9092e46.camel@ibm.com>
In-Reply-To: <cd3c88aae12ad392f815c15bab0d54c8f9092e46.camel@ibm.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Fri, 6 Dec 2024 23:48:12 +0100
Message-ID: <CAKPOu+-AwRayUqOR9fEmZ88bpJkrknMbsZadknjDsBW=jcFL0g@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/io: make ceph_start_io_*() killable
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: Alex Markuze <amarkuze@redhat.com>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, Xiubo Li <xiubli@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "idryomov@gmail.com" <idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 6, 2024 at 8:11=E2=80=AFPM Viacheslav Dubeyko <Slava.Dubeyko@ib=
m.com> wrote:
> Should be the check of
> this function's output mandatory? I am not fully sure.

But I am fully sure.
If you don't check the return value, you don't know whether the inode
was locked. If you don't know that, you can't decide whether you need
to unlock it. That being optional now (cancel locking if SIGKILL was
received) is the sole point of my patch. You MUST check the return
value. There is no other way. Don't trust my word - just read the
code.

