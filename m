Return-Path: <ceph-devel+bounces-2195-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 381E79D877B
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Nov 2024 15:12:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 78990B300F6
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Nov 2024 13:59:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F6EF1AED5C;
	Mon, 25 Nov 2024 13:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="UpQQ/ruA"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE411AE863
	for <ceph-devel@vger.kernel.org>; Mon, 25 Nov 2024 13:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732543195; cv=none; b=t91zCoez3a3F+ymEftW0Efr5lGQnA3LiyKRGUEfEyYl1rrEpEqVRpuv/CawpbY8HPS1qY1DmVcSqUzUdoUqRQXikoAQ6YC57eRFZ2ti+Dcf4VXhOIDkMN/XrX52AmNg7siEsCmb1QH92tot0h1qglwPSU3SCYcdChJlGq5yQK48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732543195; c=relaxed/simple;
	bh=E8nIC1QMQF0fv1CW6rYzP9Cy3c+iEgEnoJ86Z+Jxk7g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NnCJ5zuVbgIG64x4Ii2CfZ5wemRLLwVdcRl6b7bqwZNgl+7RaBPjoZUuifc9CylMKbvaGQhdoPf5tT6XigoA1k5KGchUzHaCRp4CdE7LhwY+uGQfGumDVR6AIztwq6Q6Rns31E9OVtLnHpPcn9WAgmzQ5no74INVvVDjrpCuhAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=UpQQ/ruA; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-53de652f242so582803e87.1
        for <ceph-devel@vger.kernel.org>; Mon, 25 Nov 2024 05:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1732543191; x=1733147991; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E8nIC1QMQF0fv1CW6rYzP9Cy3c+iEgEnoJ86Z+Jxk7g=;
        b=UpQQ/ruA98jopTJVOsqsQkJQZKduuIcLlnNCDuLXJW9ZSBt3xDLBNa5pweO6yvOiVD
         rK0dMD4DO1ie2+/WHUZyoawKH0oJjFsuDhhoeAYMJdejPgg6+AemF/OqSz2JGWZsGQss
         bz4fl2+b4wwrl+AuJ6yoeOzYdV9LrVeTISrXbTf5Rt41iFUPJcX8cBQIwYRvx9UhWBcs
         8V1nYo5LVrJIVeCUOw6SPWmyen/6rUCyl8VtaoayUG0hMlYH3+tNFDZjbLx09rs2wdzP
         7h1jsmZe2jf5nG0cKeVskXV0xZ0Ut25Ff/u7oqjwxQaGM6CZQcHP+Jval/3nzqBQiz13
         JEfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732543191; x=1733147991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E8nIC1QMQF0fv1CW6rYzP9Cy3c+iEgEnoJ86Z+Jxk7g=;
        b=LPP7euHJRW0/CZ0WI0qsVG6gc1wGuCKR3xp+jUfmvpc1Fr6aW4XUTL11Ywk4TN//8R
         dHNuhUnWdCzpT/D4c0oL6Utd1Mf3xNjuRPUHZmlKnzNjzvVB0eNpM/uThyn5iaDEd4jB
         RJCqpxz0N6X5iFR8Cv3U99iq5SvQJ8z5tALaQzAjtBDlXyTYsbB6q2GlgAKC4aZ6jHw5
         yms0c5EFk/x1WFp6tBw+7sZDztDCrCNOT49GvK0mtRLIoHsoov8jYd5zFgi9wPuv7X2t
         UMHfRA9QQSrGtIGoQGE85Wo7JX3XwvhyeBh9smRLiI3s7vg6MNv4ZB1pTtK4H4raMjQc
         kf+A==
X-Forwarded-Encrypted: i=1; AJvYcCU314aAh2p4RcwhxglBWAP9F9Yhsgq0JBOZqw5H6TIsNRgkpLbmiOxwTjVFNi4j/n8By9M40qn78JHi@vger.kernel.org
X-Gm-Message-State: AOJu0YzgptriJaw0zJg3Lax+WfDs42ana58LCFDqrme7jm43w7SmW6KL
	BoHpndgDKvC5NVqv0yCGFP+uPhNWbEq+XDzGBJmt086QqjtsheIFQCQxHYlhkQv4DIF8ZmXnpHv
	ZHg/d9lZf5hoKtwr60EY5gFL/V9ZfWar3+S2GlA==
X-Gm-Gg: ASbGncvCOQmFL48EaaXyKVv1EgyAVOXx+Qafjzl7RuCXgJZA4iiSOzVyLI0Y6UaHFhm
	Nn1oavklj/lTrWwnjwRVvnrKs048w99Q+uFZ4O4S+qPFjuJcQSOJekH75yRz6
X-Google-Smtp-Source: AGHT+IH73yZTyIDCHHrbFTIalkWywowb8ZZKOHo5jE0IO/R7trvqjhf5t9qKLZtCvrgKQHzQR0Gp6IUGA3oU75IteeY=
X-Received: by 2002:ac2:46d6:0:b0:53d:d3ff:85f1 with SMTP id
 2adb3069b0e04-53dd3ff8ef1mr4515352e87.42.1732543191117; Mon, 25 Nov 2024
 05:59:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241118222828.240530-1-max.kellermann@ionos.com>
 <CAOi1vP8Ni3s+NGoBt=uB0MF+kb5B-Ck3cBbOH=hSEho-Gruffw@mail.gmail.com>
 <c32e7d6237e36527535af19df539acbd5bf39928.camel@kernel.org>
 <CAKPOu+-orms2QBeDy34jArutySe_S3ym-t379xkPmsyCWXH=xw@mail.gmail.com>
 <CA+2bHPZUUO8A-PieY0iWcBH-AGd=ET8uz=9zEEo4nnWH5VkyFA@mail.gmail.com>
 <CAKPOu+8k9ze37v8YKqdHJZdPs8gJfYQ9=nNAuPeWr+eWg=yQ5Q@mail.gmail.com>
 <CA+2bHPZW5ngyrAs8LaYzm__HGewf0De51MvffNZW4h+WX7kfwA@mail.gmail.com>
 <CAO8a2SiRwVUDT8e3fN1jfFOw3Z92dtWafZd8M6MHB57D3d_wvg@mail.gmail.com> <CAO8a2SiN+cnsK5LGMV+6jZM=VcO5kmxkTH1mR1bLF6Z5cPxH9A@mail.gmail.com>
In-Reply-To: <CAO8a2SiN+cnsK5LGMV+6jZM=VcO5kmxkTH1mR1bLF6Z5cPxH9A@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 25 Nov 2024 14:59:39 +0100
Message-ID: <CAKPOu+8u1Piy9KVvo+ioL93i2MskOvSTn5qqMV14V6SGRuMpOw@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/mds_client: give up on paths longer than PATH_MAX
To: Alex Markuze <amarkuze@redhat.com>
Cc: Patrick Donnelly <pdonnell@redhat.com>, Jeff Layton <jlayton@kernel.org>, 
	Ilya Dryomov <idryomov@gmail.com>, Venky Shankar <vshankar@redhat.com>, xiubli@redhat.com, 
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org, dario@cure53.de, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2024 at 2:24=E2=80=AFPM Alex Markuze <amarkuze@redhat.com> =
wrote:
> Max, could you add a cap on the retry count to your original patch?

Before I wrote code that's not useful at all: I don't quite get why
retry on buffer overflow is necessary at all. It looks like it once
seemed to be a useful kludge, but then 1b71fe2efa31 ("ceph analog of
cifs build_path_from_dentry() race fix") added the read_seqretry()
check which, to my limited understanding, is a more robust
implementation of rename detection.

Max

