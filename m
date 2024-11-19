Return-Path: <ceph-devel+bounces-2187-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EBB49D28A4
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2024 15:54:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D6501F23573
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2024 14:54:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BB4E1CF293;
	Tue, 19 Nov 2024 14:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="b+yqNkfb"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A05199240
	for <ceph-devel@vger.kernel.org>; Tue, 19 Nov 2024 14:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732028087; cv=none; b=gZomPQOp71e50a3aVWsmOH1jPNezTo19hCeLgLkSKTIuAwMp0TMi/qcm5b3aBZJz7A8bBxaAN+YGKh8tHaT/AgJXa7Pk35GJ1ynFNoNfZZsOKr6851rzQ6xHTaRTqHGjmTRbZr2c0Mc252mhk556p5M2yTZvbWejtzpvYH3dJYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732028087; c=relaxed/simple;
	bh=y+k4CazNvujMU74lD4Cw4HxpVoXKoadx5aTCGAmeTkM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f6hqsMmAkiWeyTB1CK9GK6aWJsDCOZ4phCC3786zT8n+hUOhoSF9o/lQlNVljfuxCrvnN+A+OYXgp3EnRWhjBXHHOh4SnUhGGBkDKE81JQqYmw+BUXljuoR8paWoZYPJ0FUWKwpUjnOUy2zFx6FRs6d6dxJ9+7TzofDLoytLqAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=b+yqNkfb; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-38246333e12so2385107f8f.1
        for <ceph-devel@vger.kernel.org>; Tue, 19 Nov 2024 06:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1732028083; x=1732632883; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y+k4CazNvujMU74lD4Cw4HxpVoXKoadx5aTCGAmeTkM=;
        b=b+yqNkfbNcJQHjYcXNoYzMC1hEX85s8+z1LTawIM8BFN8ZSMwtTI9QaDIBTEvCCS7n
         +OAMCXNX0fPxyPxonavP7X5Ql6vR2cIplgQKZc/cmgqJj0O7pHJ4KYqXtj/jLiJTogo3
         dK8P3WlsZOfVyMhqOnGYJh8xGNIKml18btYloerTEn6zicuunbIS5WOEGPKKsfug0xz7
         QyVxih0JMhnhGKxEbwJ5aKxlyHJSCk6oS/kHdMznsrVVYgsb+YsrPcxiC98Jy/17Dcos
         lSQZl202Y0zLCVHh/O6N6vSC6/C5Lymbn4lOAKYzZWj4pRJbAoC1YWXf84QNPu5A0RJI
         z3Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732028083; x=1732632883;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y+k4CazNvujMU74lD4Cw4HxpVoXKoadx5aTCGAmeTkM=;
        b=OBjv3zzAwzQa/hYfB7eFse1n5hXUcG75jrT3XXhyavcOFAjsFit6XAw+W3P6ImLb9G
         SfqSQNVT3EVPHgw7jT+O4gCJ6TTtXoBP1AD+Jq9ncBmZrdsSuWlPDfTXo0j9ZJ9iC7Ey
         PIHFHHMR3jMLxDCMRNJlXJL/eMG7FlWBxqWBaw8TJyO8oxpg2mhbml2nXXuW/StMAfDB
         dficrkZNmq6fx20x1dLwcGl+TZAcU4pyC2HIaPPb7CX72xnFtBEgwIVhFIkCi0QJNIGq
         jGB2lVuKVjnafNFPQ60IpT3p6GdhZtyGEA7wq2y4kQzdc99JEIKW7RS5nXmak9/I/Cio
         jB3w==
X-Forwarded-Encrypted: i=1; AJvYcCWFLZDIM4Y821Gki4eqztGgLI7siklqOMOC00ecycblPiS/gR8Kivm5rXBwYC6B1XEnNHsiNMyloZBx@vger.kernel.org
X-Gm-Message-State: AOJu0YzIpxl2Y0yQh20V9JwOl/r2KIffN4PwpBkJJPiLYzp3CUwAjHd6
	0P8i2vrafwXIUWnwb33oFF36bROYRnlLIDKoBd68Q1OQP6L9DehV+QGBHKo5pPgh2s/3V/Q+0Ep
	+MHNuP4dFinK9GkMNG1j5FrUpx1JJkTwLyqEzbw==
X-Google-Smtp-Source: AGHT+IGuKk4gG4vY2G6qz9afVz/KqkacpJNrLmnb5kFxR695mDP43aiJMoLRGZeY1f8uPQkmwuJwMCBH3Th+igQwxWI=
X-Received: by 2002:a05:6000:144d:b0:382:440e:4e88 with SMTP id
 ffacd0b85a97d-382440e521bmr10076471f8f.16.1732028083591; Tue, 19 Nov 2024
 06:54:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241118222828.240530-1-max.kellermann@ionos.com>
 <CAOi1vP8Ni3s+NGoBt=uB0MF+kb5B-Ck3cBbOH=hSEho-Gruffw@mail.gmail.com>
 <c32e7d6237e36527535af19df539acbd5bf39928.camel@kernel.org>
 <CAKPOu+-orms2QBeDy34jArutySe_S3ym-t379xkPmsyCWXH=xw@mail.gmail.com> <CA+2bHPZUUO8A-PieY0iWcBH-AGd=ET8uz=9zEEo4nnWH5VkyFA@mail.gmail.com>
In-Reply-To: <CA+2bHPZUUO8A-PieY0iWcBH-AGd=ET8uz=9zEEo4nnWH5VkyFA@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Tue, 19 Nov 2024 15:54:32 +0100
Message-ID: <CAKPOu+8k9ze37v8YKqdHJZdPs8gJfYQ9=nNAuPeWr+eWg=yQ5Q@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/mds_client: give up on paths longer than PATH_MAX
To: Patrick Donnelly <pdonnell@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, 
	Venky Shankar <vshankar@redhat.com>, xiubli@redhat.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dario@cure53.de, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 19, 2024 at 2:58=E2=80=AFPM Patrick Donnelly <pdonnell@redhat.c=
om> wrote:
> The protocol does **not** require building the full path for most
> operations unless it involves a snapshot.

We don't use Ceph snapshots, but before today's emergency update, we
could shoot down an arbitrary server with a single (unprivileged)
system call using this vulnerability.

I'm not sure what your point is, but this vulnerability exists, it
works without snapshots and we think it's serious.

