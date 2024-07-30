Return-Path: <ceph-devel+bounces-1618-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F53A941914
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jul 2024 18:29:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AD90281B8F
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jul 2024 16:28:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BF58184535;
	Tue, 30 Jul 2024 16:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="HT0hz34A"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34BC1A6160
	for <ceph-devel@vger.kernel.org>; Tue, 30 Jul 2024 16:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356931; cv=none; b=AY9y9vu+vuIkNVh+N1AUczLXZgpaEzM22XWbToPqlM35+NUwSc1tHEBn172qhwtBxNXhpU86lAI0r5pn+CBoZP/s8bAUcYXu86k5qvKMFObYp7JVsPMc+d1ie5O3wu3TMEg/pXOGxJ3gVMhkJ0wFcmF6QIMuXaeMM1xmWOvNKsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356931; c=relaxed/simple;
	bh=/WrqX39V/EGZlU7gkM+jA9j7Jyn0OjEJ1Mehdy12oxs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LUw9lEXt3DjadspNYD9GtdHaBaQlasr+FpTjyZk/zvwBPirsExteCaaNclGyptIbrr0Juw8DQZOH0sww/K1HnoLioj6bKhGB3ATSG1sKMtXRYyeeJs0Fzu29UQ34nA3TUg+SH7F+cVA+ammA44pkxZeDMERStEuwKo/W+artd3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=HT0hz34A; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a7aa212c1c9so654595066b.2
        for <ceph-devel@vger.kernel.org>; Tue, 30 Jul 2024 09:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1722356928; x=1722961728; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IfuNs9RJBxSHtgXaAG8xtdh6dR8/ZJRWqaxb2ZGOGQw=;
        b=HT0hz34AV6AQOhCDOqRoWZOg8kSqMBzmx3P6JlVSEUBoBqcFqHofONDiRu4Te+WWVq
         p6Y9EKYcyc457hg/5hRi9b9iZ6xBfdo5bQRyEEIpwQ4XnSNZAaCzf7TltKeESxQMHeLe
         mtVXoJQ+ti3kIitz3bRxYaMul+afdcJDVDujtjjkvBj08on3jxBFcipcMnjJ7H14hGg8
         Y8le95YOsIFhqGJ4oaFJPfQpa8G+12t+p1KcxSwncNJeNzUv0YowLBg+rbE/srCOuhup
         3wRKfhcWAskV8UVaHV+vaminX6hgYEY2F08gIfQIvJs4F2V8k/q6TGL7qR66XHH0RAQv
         wwYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722356928; x=1722961728;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IfuNs9RJBxSHtgXaAG8xtdh6dR8/ZJRWqaxb2ZGOGQw=;
        b=Mz+QONcN0+QABdjjFQqyQOcMy7TCDKVjPdGbRTcTKX4lhbff7wDha+AZN+F6dKshNK
         4qWIK44lwy6s9SXiVVEWHZ55uSS4LES1eo1BZeoBVaowXr5w/UxKCQCRI+CgOKrfrBNz
         8EUA7S7LUP9RqZPJonjcHjeriKwyVHWp8tOX1v5ChAkdv/wkt0bNXoVLCN8zI+N4PDZw
         9v2iut/NXnWNsykK6/tkC08O8NNfvfv4UDC+rns2jMQPVjIjmWFwjSn5Ew80z2y1v6Jo
         XbTEZm2V/BGupbv3Op81bBLe3CgqYIPOoukbXSC/inpd+9tVhnAjuhsycz8TxHEU+4j3
         /etA==
X-Forwarded-Encrypted: i=1; AJvYcCXHtPZvyH8RbLJiDDynGY00BLHto6pU3fFTkknifpkkfBOdDjyc9zKIoHyV7n7n2AyCGlY3+IBd9Oe5ItXUnZEBrXK0MJZDJHl5pA==
X-Gm-Message-State: AOJu0YzKPkuqGrIEyL2aDt2KFLZRguO9GgiIDif1Lq6J0dSZORA35nMX
	FH8kvKKdCc83L9jgorrcRO8u6b+b3JK8ojsIciX+IIADQ6gnZpFBJ6sBroLgwYlH31vkSr+I9Zh
	mpiuWByjju4xFYnSJFtqqpIsT7cdA9nmHvDtpig==
X-Google-Smtp-Source: AGHT+IG1VcMHenRJE4OMv8Wdwm4JETBLEpAvJgISa1/m5vlwH5K/nlA4PdfCRxYRpOU0UfdTVOnSQCZN39wxbmaGSUY=
X-Received: by 2002:a17:907:96a0:b0:a72:7da4:267c with SMTP id
 a640c23a62f3a-a7d3ffa612bmr940477966b.12.1722356927933; Tue, 30 Jul 2024
 09:28:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240729091532.855688-1-max.kellermann@ionos.com> <3575457.1722355300@warthog.procyon.org.uk>
In-Reply-To: <3575457.1722355300@warthog.procyon.org.uk>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Tue, 30 Jul 2024 18:28:36 +0200
Message-ID: <CAKPOu+9_TQx8XaB2gDKzwN-YoN69uKoZGiCDPQjz5fO-2ztdFQ@mail.gmail.com>
Subject: Re: [PATCH] netfs, ceph: Revert "netfs: Remove deprecated use of
 PG_private_2 as a second writeback flag"
To: David Howells <dhowells@redhat.com>
Cc: Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>, 
	Jeff Layton <jlayton@kernel.org>, willy@infradead.org, ceph-devel@vger.kernel.org, 
	netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 30, 2024 at 6:01=E2=80=AFPM David Howells <dhowells@redhat.com>=
 wrote:
> Can you try this patch instead of either of yours?

I booted it on one of the servers, and no problem so far. All tests
complete successfully, even the one with copy_file_range that crashed
with my patch. I'll let you know when problems occur later, but until
then, I agree with merging your revert instead of my patches.

If I understand this correctly, my other problem (the
folio_attach_private conflict between netfs and ceph) I posted in
https://lore.kernel.org/ceph-devel/CAKPOu+8q_1rCnQndOj3KAitNY2scPQFuSS-AxeG=
ru02nP9ZO0w@mail.gmail.com/
was caused by my (bad) patch after all, wasn't it?

> For the moment, ceph has to continue using PG_private_2.  It doesn't use
> netfs_writepages().  I have mostly complete patches to fix that, but they=
 got
> popped onto the back burner for a bit.

When you're done with those patches, Cc me on those if you want me to
help test them.

Max

