Return-Path: <ceph-devel+bounces-3658-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8C4FB81C05
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 22:25:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A622581DA5
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 20:25:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B633A2C1583;
	Wed, 17 Sep 2025 20:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="E93ViBQr"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3FF22F74F
	for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 20:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758140749; cv=none; b=g6uge/Fns8sd4yGLNlDOy0RMuEOvKaSMfz+ZOZZDVAm4KE7d755ROs9JTbwHbkTgIedOZ6iUb5Q8d4180bOJx+aRKGiGfA/GTLj1JOrCZECMu0HY+s+XrbFpP55OJusEoMIM3yiPy9humEv2pjP+Ngg44qh0cVJRFi6fxPAb03A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758140749; c=relaxed/simple;
	bh=K6d/jzhMMI4CPpQDgjpBmEl98KL3cG+euC4yxGzEVCw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CPcVHBgUoRRymFmyFeXXPpCFl1/qz+1RmiGEwFOBYBrJyX5hWXptBu55AGBc2LjFh+XeH5qmz5tlCU3FGbBivgnv5qvu61dBRknGRCFbJE7zPpT4J4dVhzL9aIdLJvTe10hww98+FkcnydraUqiU2Ln/V8nTsoap89Qj7EDElPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=E93ViBQr; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b0418f6fc27so34638566b.3
        for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 13:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1758140746; x=1758745546; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RhNK71BU031VL7GqxBW1Krt0QEpivweMDtH+UA/VF5c=;
        b=E93ViBQrlMJp2YF9PBilI+D4r4dqMY3kENfrRihA/DLYVvQ3tFSLBlr25yGkNQZSeR
         EvQ7C8EP9iYqCNcBmELAqwIYVELvBY01wXh1NLNH9pQelcTa3DBev1jJ9ZHywMfyQxiw
         jMskuvUL5nGW6CCje86E6qhKG7P8MZmMivlYzSl8zDKmxPEz1hyVpavb2LVlVOkvdWvq
         t3mPCff8/kzD1pdYyXAaFS5AF5PgHpsbs5DZiPHn0GSw5470xGRJN8PyzjDov6RbA/pg
         +ABF1T3cG5N6e6IE/Agbc6raLoM9Z7HCVkzSaFJMfkFcaUrwPUh4WxDRuf55acq4s8zE
         BmZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758140746; x=1758745546;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RhNK71BU031VL7GqxBW1Krt0QEpivweMDtH+UA/VF5c=;
        b=fIn4T61veezz3Hhi9RveT7s+8UpdjENY2Rg9w1UzXwXpqOqc/aKAK9KXC7dWUNTiSE
         x5msLjQYDeMLHaOUK7yQn8jE5OX/TIfZMXbi++CMErC24LI/DLifJz7ZDVI+jFPFMN36
         6cmIz/6LHTDn9hXWmCYq85w1Ah2jypj5WgSJlYVyLQbFTL3ymfyhHngwbIRQRLnVVBCu
         aAbJxKAU4jVobpYvFxuN/csdDg1SEhqnEmeSGSqk5Dwr9eJ3ZcP/hC/XZ3qJ9PgoTF9w
         nueLbIjP/X1OLAFDSwfBqsFwiR7whOVKR2PShIWeXNGsbyvdsKGL092ecL94cF8kDdyl
         MYtw==
X-Forwarded-Encrypted: i=1; AJvYcCWPXb0bmyXHDHgNGT8+x7Ef4ModH4ALZBYF/thd/quUPT4DjC7YQ2RI6o/gD6T9PCyyXdCpLjynQrpG@vger.kernel.org
X-Gm-Message-State: AOJu0Ywp/HQ+qNeJ8c6glAfcd0Nlh+xrKyanocIkuvLnJ1bxz5e9Yflt
	dCXQrIzT5o2xt+GFgpE/l7nBD1dYqQgUNK/AedSHHDFTKAMbW5kaIxM8dLF1d1cbBLlTy6bUYhS
	3ToA5ZEdwzfCioOSAfe+Q6Wv+1BmSBbDYjf9ocFDOkQ==
X-Gm-Gg: ASbGnctOrX2iviixoqQ5plTX8AcLgiNdwMBcr6vqpfAE56Odhh8vtyk8wMGrA/PA+Mg
	W7hN+azZU2e+6N8EuEuutfQ69a790tJYzOiSPI8W89pUv9BfAlHAlD5IaVKdMlfEQ6M1M0bGa3U
	G2ZzoXCI6wWBei9/cv8w5PuQ6pq88zq12PKEWj8q8GbKJKcZp8KpEOqrewWHSQZd2qojnb0LndW
	1bZKUdnQjyI2pifT6UGvTMM+8udIxmgzaWxPj4/KldH3v1EsKWWB9Hy24MCYk1Mqg==
X-Google-Smtp-Source: AGHT+IFBvtsDmLFlrUPLrEdtXlj3XmnDOunMGaQVNwpHnx7V9K8cWA1KerJzVQIV4Og+xzCob2fZntJ3zIqyp+GB2lY=
X-Received: by 2002:a17:907:3e1f:b0:b04:2b28:223d with SMTP id
 a640c23a62f3a-b1bb6048f2cmr368398466b.20.1758140746182; Wed, 17 Sep 2025
 13:25:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250917135907.2218073-1-max.kellermann@ionos.com> <20250917202033.GY39973@ZenIV>
In-Reply-To: <20250917202033.GY39973@ZenIV>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 17 Sep 2025 22:25:35 +0200
X-Gm-Features: AS18NWA9lLP5Eqngelj0xlWoIoGVHH7XtsnclhYX2neNhHDUumPEaBrniNeVLQk
Message-ID: <CAKPOu+8eEQ6VjTHamxZRgdUM8E7z_yd3buK2jvCiG1m3k-x_0A@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix deadlock bugs by making iput() calls asynchronous
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: slava.dubeyko@ibm.com, xiubli@redhat.com, idryomov@gmail.com, 
	amarkuze@redhat.com, ceph-devel@vger.kernel.org, netfs@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Mateusz Guzik <mjguzik@gmail.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 10:20=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
>
> On Wed, Sep 17, 2025 at 03:59:07PM +0200, Max Kellermann wrote:
>
> > After advice from Mateusz Guzik, I decided to do the latter.  The
> > implementation is simple because it piggybacks on the existing
> > work_struct for ceph_queue_inode_work() - ceph_inode_work() calls
> > iput() at the end which means we can donate the last reference to it.
> >
> > This patch adds ceph_iput_async() and converts lots of iput() calls to
> > it - at least those that may come through writeback and the messenger.
>
> What would force those delayed calls through at fs shutdown time?

I was wondering the same a few days ago, but found no code to enforce
wait for work completion during shutdown - but since this was
pre-existing code, I thought somebody more clever than I must have
thought of this at some point and I just don't understand it. Or maybe
Ceph is already bugged and my patch just makes hitting the bug more
likely?

