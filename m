Return-Path: <ceph-devel+bounces-1572-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BBE893E583
	for <lists+ceph-devel@lfdr.de>; Sun, 28 Jul 2024 15:17:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 04BCAB217E4
	for <lists+ceph-devel@lfdr.de>; Sun, 28 Jul 2024 13:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAA3D4174C;
	Sun, 28 Jul 2024 13:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="TevXsQPu"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9962339FFE
	for <ceph-devel@vger.kernel.org>; Sun, 28 Jul 2024 13:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722172655; cv=none; b=Nd905pRr8bapvx/OxKsFyu5BoagM6oZzR+k2uBBOOhVnA/tdDKvLbCuv8d0zkehuJoi0MfQ9jxzBWRPlIefYZzxZQ9HAAkEOadRzRZXgRdL6yKyOe6/nrRi2uMOdhHfj2jOnYUB7F9pnMy8+TXzDdWxA1LHtkFRy/4fR7mNPgjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722172655; c=relaxed/simple;
	bh=YdPY4IU2eccFTGlXZkRJ9P/W2uFYRJ5/DSkvzOfwor0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i0vXHadbG//ix7O+WL1+l7bCAsgD6rqwoVl3BeQFeR4UZrzH8897g4Spy05d2MKSGIXm2eMXBWMIQ536fMu5mMMCZPHjSzTMNtsMm2xueND110xQEXJNon3KXpwipy5t2jzPgru66DpyBq+ICdCFoXQDQu3YdOeRbhIQQlOy8ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=TevXsQPu; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5a10bb7bcd0so4534726a12.3
        for <ceph-devel@vger.kernel.org>; Sun, 28 Jul 2024 06:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1722172652; x=1722777452; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YdPY4IU2eccFTGlXZkRJ9P/W2uFYRJ5/DSkvzOfwor0=;
        b=TevXsQPunU0TvTJ+MF4jB5KfKegkP9LmBhMvdRjxnZ9hx/2E7jwWOJX+e5QxHgskEi
         CVCu9+mxAOEWrCkS2WNGDNE1iSOKoP6CAv7yUiYBa1aWBM/7kcvfczsEqvvQJ/5Y9IEZ
         JraWmvji0h59MtQ2lLxXDAMQ/nxoJr7c9HXcmZjSx3tM30opMbHyvTYZ+U3VHSFFC6JN
         BeM0+9Q0phqio3s0Wq4VqqBxiSX1oXy+EBKj8Vs8S3GndAUimsp0lf05Jf5NBKLKjQ7S
         c90UwSvNXHpKqXMxnpgTo/JrqWoGCAwMB+LrFykpFFdnndaDfS+XEMxm8oQsdKlr6bpH
         Copw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722172652; x=1722777452;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YdPY4IU2eccFTGlXZkRJ9P/W2uFYRJ5/DSkvzOfwor0=;
        b=H0Qe8iS8U0pzyDKhAIyzBWuoIFtIV/oG71PlYla7kqHcsu/I2oQgshkrHYaX7sNY4R
         JV2ZgJHDgbMiD515lU0fUlFiAclaqhYdoYcnQLitb4yX4dXPRf9hA6BHefa6oCRIlJB6
         9spJdcRQ+JLQ92mqcCZhWzoFaMJ2nbzAAdSA4xspCdWRTpHJH4IjNBXCnJU7p7+u8t6O
         eDCS4JtQ3afRNEo4d0w3ncqunypAPhvF78n5QsOSKd/FY+Yicis3771qMvaUSsTohJ7c
         tZQrw9McwZzhDGXSWyHqNDxbgn8muXiWchHGLUz9EvElnD8S7eLVUfloFtFjfJGLrnri
         z1mw==
X-Forwarded-Encrypted: i=1; AJvYcCU7MILlCgLCWCNRqpmjKbkaD8WaI8Rax7YJC97vu2LNHXz/gqcyoJyErxsc/j5+zl0iLZwN00A2ss0dqHOanI6a6A5DlsERoSz5PQ==
X-Gm-Message-State: AOJu0YxCndaAoDVFOLgagdBkE+rdsOY/m7KHJ1KkU2CuhCDGEjc6pt6E
	PfrmZC23d2QwoQUtMuBzsDsoqkRBhQVZjkMgFYZB9IiuG4D/J1QkXqIZb3W+6oDa9w+xuT3iGS9
	REOa6h+5XDUPCoFxsCIQ5W0nXVPIFDocVC9q77g==
X-Google-Smtp-Source: AGHT+IFmZb6t693nBDAauF4mz3I52hdcdUju10lRZJqwwIsQAzHcx3rYJaYLkglaOjBj3RpAbwI7+n0a8KqtAUqO0Tg=
X-Received: by 2002:a17:907:36c8:b0:a7a:9a78:4b5a with SMTP id
 a640c23a62f3a-a7d4012b2dbmr289617466b.52.1722172651450; Sun, 28 Jul 2024
 06:17:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKPOu+_DA8XiMAA2ApMj7Pyshve_YWknw8Hdt1=zCy9Y87R1qw@mail.gmail.com>
 <e5f8c7b5d0657bcb10daa6fe268a62a7ed1b7672.camel@kernel.org>
In-Reply-To: <e5f8c7b5d0657bcb10daa6fe268a62a7ed1b7672.camel@kernel.org>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Sun, 28 Jul 2024 15:17:20 +0200
Message-ID: <CAKPOu+_5YjJnm_4KVehELsWLRWpET-pPWo4VH1GFK_xtgd2uqw@mail.gmail.com>
Subject: Re: RCU stalls and GPFs in ceph/netfs
To: Jeff Layton <jlayton@kernel.org>
Cc: David Howells <dhowells@redhat.com>, netfs@lists.linux.dev, 
	linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org, 
	Xiubo Li <xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 28, 2024 at 1:45=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
> That is really weird. AFAICT, 2e9d7e4b984a61 is just removing some
> wrapper functions and changing the names of some others. There should
> be no functional changes there.

Exactly what I thought, I could not imagine how this commit could
cause such a bug. The only chance was that netfs_rreq_assess() now
always directly calls netfs_rreq_completed(), but not
netfs_rreq_write_to_cache(), but I don't know what that means - this
different code path could be a candidate for doing something
differently. Maybe it's an old bug that only got revealed by this
change.

Anyway, I tried to verify this and the preceding commit for hours, and
the picture was consistent: that commit reproduces the RCU stall
within minutes (though only 50% or so of all boots), and the previous
commit never did. There is still a tiny chance that I just wasn't
trying hard enough. I'm out of ideas, and all I can do now is start
digging really deeply into this code, but I thought it would be more
productive to reach out to the people who wrote it.

Max

