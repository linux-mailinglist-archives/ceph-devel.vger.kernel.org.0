Return-Path: <ceph-devel+bounces-2264-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 93ECD9E7864
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Dec 2024 19:59:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 61AA9188583D
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Dec 2024 18:59:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56A9B1D61A5;
	Fri,  6 Dec 2024 18:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="SlQNnN6z"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0ACD1BBBE0
	for <ceph-devel@vger.kernel.org>; Fri,  6 Dec 2024 18:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733511548; cv=none; b=PgZ1hp1Ce/IRNq2fjKrqGFMLtRTVq18swrmEGJBwuyxP3ORD8KrAzS6wl5fOdDRDmMTwE9LRm8T8WnqItwGjyhd8j7nNflFdm0cRxhQzHUMrIEaxdy0VxA4Cr4/NsBTnwwytPCjYm+neXxBWAS1pv6f+qkecgYZu5JjzSlv8dRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733511548; c=relaxed/simple;
	bh=qvhNRQIAECvbL+0VG1lxnA7oddJW2svBem7/G/lqUJM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fxxrpHxXEiJcnziLJo3QM3dJI1Ir/yNf7MDvpJLLxk89OLhk7vgqr0r4i9pRJTtQL+3mhlAFUAhBn4XWELnHl615X1bRTMQ4k9ziI+wVOFFzqFOZqkVUZfJjIkPUEKaUnsYsrsbbZkMQ9Gc+h3/zxczO85oD8UMTSuoHJbsv17c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=SlQNnN6z; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5d0d4a2da4dso3894198a12.1
        for <ceph-devel@vger.kernel.org>; Fri, 06 Dec 2024 10:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1733511544; x=1734116344; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qvhNRQIAECvbL+0VG1lxnA7oddJW2svBem7/G/lqUJM=;
        b=SlQNnN6zdK4TkzKQ5ZQRq3kt/Y5/793dbz9MXmn6jNq5VWMGyr1fJggJQoZY6sK30g
         c0grksrdjc0XutwIXxUX715kTp169IMDTUunVs0RXCNJTKuoXji4eWsdOum1pwHuBQHD
         mEAVi8T17OAF87Hco9kMigM0OExGgrY1+Zf7lgLiNE/6OBD+Kj2JovieTBv6hXsjXpMk
         ZK7uNZDmvxrTUflEJEYnf9qh1dOi+6/Ieu9UCY5t/k0kLZ1Z/lHohIye9kuQsRHdKTsV
         PSv0wJVSrrHSdCbxvBKwxh1cin34ysT9SuTc2fmYEdav0fOJvZPjTErGBxDvRVFswvHY
         Feqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733511544; x=1734116344;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qvhNRQIAECvbL+0VG1lxnA7oddJW2svBem7/G/lqUJM=;
        b=E8w9MuAAHeQix45bPErQQHk+mINQArvDTiMOECcY5TBQSZ3Qwcm5BFuciuyhg8t1hl
         8azDzoD+uotL4n4AL4rvLCkDF0u50n+RjVTx5NYY/jm2fCVkxLkTV0Ur7z+njXILa/H9
         PDY0kgT/PVCq2KH0SsClG5rVQOo0iUj93kVj0U0O2WhTlqxuLmwQStUMLJ87s+hwqsQV
         EjcjT7lASVOvUTLrD0UvLH9eYm99lUxkSNaMBTbfCaIkdo1PdwfxEMe8aZ7/MJQHmbgq
         ABEkQed3UOFIUtxepVghox9Qj0O8yOuECrFYspUGfGhCkmhIeJcr7fu76ODa9pqg3LHU
         KT1A==
X-Gm-Message-State: AOJu0Yxt8MtnmqmDK8vLVlDTqOqrh4XhYAGamDKzWQYnSHhkan7BkKoT
	zq3b3Y62JS9w+UEJgwDxxPdzpwq5c5TYSP/84FbA41q7UzRjRrpoOtgu1tcvxZ309JgokawzV6M
	6yyfxhDK3tcRiJjG+YXuFILVH8rvgNBK7/orkzA==
X-Gm-Gg: ASbGnctakrJGZ/KV6k8CeX/hrkA34crBIIwOksDCUlD5KQWSHU3z2XyYh9mJ/yFudRk
	C0X1VPqB4tz4OYFgjAt7IlLJbX5JrCesibw8jGbn1KnUOJLUPjnFbGia9SCPf
X-Google-Smtp-Source: AGHT+IEZkQPyXCR4uOK6IK+7iMGtI9N2UA3WQnIEWS3PfzkwiaTdI0znHc1LZzLWnawwvXRfJnIiJQw3NcMECSV2HYo=
X-Received: by 2002:a17:906:3d29:b0:aa6:3f32:8910 with SMTP id
 a640c23a62f3a-aa63f328c25mr370447566b.56.1733511544014; Fri, 06 Dec 2024
 10:59:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241206165014.165614-1-max.kellermann@ionos.com> <d3a588b67c3b1c52a759c59c19685ab8fcd59258.camel@ibm.com>
In-Reply-To: <d3a588b67c3b1c52a759c59c19685ab8fcd59258.camel@ibm.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Fri, 6 Dec 2024 19:58:53 +0100
Message-ID: <CAKPOu+-6SfZWQTazTP_0ipnd=S0ONx8vxe070wYgakB-g_igDg@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/io: make ceph_start_io_*() killable
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, Xiubo Li <xiubli@redhat.com>, 
	"idryomov@gmail.com" <idryomov@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alex Markuze <amarkuze@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 6, 2024 at 6:40=E2=80=AFPM Viacheslav Dubeyko <Slava.Dubeyko@ib=
m.com> wrote:
> Do we really need this comment (for __must_check)? It looks like not
> very informative. What do you think?

That's a question of taste. For my taste, such comments are (not
needed but) helpful; many similar comments exist in the Linux kernel.

> I am not completely sure that it really needs to request compiler to
> check that return value is processed. Do we really need to enforce it?

Yes, should definitely be enforced. Callers which don't check the
return value are 100% buggy.

