Return-Path: <ceph-devel+bounces-2888-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B74C9A600DF
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Mar 2025 20:15:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E8E2188FD1F
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Mar 2025 19:15:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF2B01F130E;
	Thu, 13 Mar 2025 19:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="HnpctnXl"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC5A1EE7BB
	for <ceph-devel@vger.kernel.org>; Thu, 13 Mar 2025 19:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741893300; cv=none; b=l9yj5dod8u/70lTnf7Gcw53qb2SaB5hAk/4Ot6Q3A5I/O07pAnwNS5x8rm8nYw0DuW495mrIGXjR6AtslROxL7e50ZQo4Vo1v1ez57epNoytiO1zG2socj9AuSA+jM0oyxZdlYBaFlLH/f7LHNzRljp9lMogkjnRnQsn8WO2d/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741893300; c=relaxed/simple;
	bh=Zb+ZXYsETYl//4H2xcjbCVAdiU5mtxxYtFbhePzBlTY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fBL+Dsn6XB7cLlPhVTrniDu715+zEMsbsga2taWC7j5vSceyCDo7nEunD7BXduaBVZpylI9MVlo4KHE0vdZpek86aFu6JFasGsAIZzeHOMrZhQFPz4DrZ0wGCDQUTFtQiujjzaq3Uxbm+/K/PgqqVz8giS+e4G7URWSm5Taa7UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=HnpctnXl; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-22435603572so24912135ad.1
        for <ceph-devel@vger.kernel.org>; Thu, 13 Mar 2025 12:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1741893298; x=1742498098; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Zb+ZXYsETYl//4H2xcjbCVAdiU5mtxxYtFbhePzBlTY=;
        b=HnpctnXlP1sSHNqPi+sBd6CeYKJ9gI9vZit7d4kUFDIZa7mM40s/4LHr5MkzAR11cM
         M6vWT80oVR1ULNjERJTMoOnFHSChEPGTWEhxEfePAS4fOEiTfZ1obuavIPamydJaix+P
         IY01HTh5btMgZjo99KX+hlikgBz9u3UNIPIaiE5X96MX0LkKjl/6npUjhTfD4woRh/FF
         qEtxWMOWU9IdZsfwMds4z2UVbqaZrO5tevyK2/jE7lwUnVYpPe3F3CDPErGduHFfkbe4
         EZZQGCnmxRakijxfkiQV8Szb5+poIzI3zr2Fhn+QqRt1eU8Tf7rs74HMjMFAsO5udGRz
         tlRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741893298; x=1742498098;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Zb+ZXYsETYl//4H2xcjbCVAdiU5mtxxYtFbhePzBlTY=;
        b=pFDH0CQT/4om1CFsWA9gzx7YQmPQm5lp99xLrpm9nOENCVbitcOr0UcH+DaqhCGMFs
         Mz+akp0UD63t7OkCtGMikTTDaaWbluql95jcIlnvb/eB93H9hMb7ibOiBmJcXBKnOWhZ
         /g8KVvQ1eF+PI59SE9FqRvDULtjncwMqc3qUNiMe0DL76zHMtvxd30I6mwBDstm9P+qW
         FswIk6oCfui8001YNgSsklByghlSMpOEIGfjBLw3RRKqXQjN+MdAEPV8+gcwtele0OSf
         SEA8g7e+yA1cgDHLUUltpmyHNsYYBrBmRpsu9chx2p24LvGzyqMcSmgB+a0yDnSjYSx8
         HgdA==
X-Forwarded-Encrypted: i=1; AJvYcCUKRIq3sBy9ZbRJA0WfkuODGPtphOxW2LvhxPnsDACGM60dysgUdZ+jdF2Odgps9qw42gbaTcgu7I4j@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9uqlSNc78Q7btx1D/u+8fdG1fvPs3TzAD3dF3eeWUplOBb8e8
	fkVrOYztkYPKQxdSUZ/giWBmKg9vqN9QT64iYa0pXKqOgR7g6CDMZNyRnlhsxoY=
X-Gm-Gg: ASbGncuO7L6NgYNuRkQIG2LPK2+BkHN7mWxvqzdq3nScwdHS0XP+rsaduXZf6uAyP3D
	xEyXBT75r8FMr/7tuxdHzvPyYw/1n08clo8qVLV02D3h2Ys3fvvs53gvaEcToQqh5P09OBqrWZu
	CDAHt+pU7ttM87X3k4n67kHSLR9N3vgXSoTHH8pAOiR4sstaRhp28iIVZgmEmraua0KRHdctW7L
	+lDTyw/g62JdegNbMNIZdhXib8xO1JT9U7q1YT7PmJtTGMfEG3uonTGtIU7w6IbDPDijVdbXuHy
	Ubyu3K7uXu87NmsiZ7urQ8Ot0ro0FAaF47uRZA3LpopQ0I6htmhOfSxtqC6bZJbMD0iPOD4H+mQ
	+K07FdL5fu4I3K8DR
X-Google-Smtp-Source: AGHT+IHHCeOtgNM+OytPitUTVjyp5IT+qMTAy7sJY2A+L7brq+8vKqWK5JWvWBrxjO7CL0wONpevIA==
X-Received: by 2002:a17:902:e78b:b0:223:33cb:335f with SMTP id d9443c01a7336-225dd8318c8mr8102905ad.3.1741893298125;
        Thu, 13 Mar 2025 12:14:58 -0700 (PDT)
Received: from ?IPv6:2600:1700:6476:1430:7c68:1792:75b7:f9af? ([2600:1700:6476:1430:7c68:1792:75b7:f9af])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c68883adsm17091615ad.47.2025.03.13.12.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 12:14:57 -0700 (PDT)
Message-ID: <3cc1ac78a01be069f79dcf82e2f3e9bfe28d9a4b.camel@dubeyko.com>
Subject: Re: Does ceph_fill_inode() mishandle I_NEW?
From: slava@dubeyko.com
To: David Howells <dhowells@redhat.com>
Cc: Alex Markuze <amarkuze@redhat.com>, Xiubo Li <xiubli@redhat.com>, Ilya
 Dryomov <idryomov@gmail.com>, Christian Brauner <brauner@kernel.org>,
 ceph-devel@vger.kernel.org, 	linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, 	Slava.Dubeyko@ibm.com
Date: Thu, 13 Mar 2025 12:14:55 -0700
In-Reply-To: <1385372.1741861062@warthog.procyon.org.uk>
References: <1385372.1741861062@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2025-03-13 at 10:17 +0000, David Howells wrote:
> ceph_fill_inode() seems to be mishandling I_NEW.=C2=A0 It only check I_NE=
W
> when
> setting i_mode.=C2=A0 It then goes on to clobber a bunch of things in the
> inode
> struct and ceph_inode_info struct (granted in some cases it's
> overwriting with
> the same thing), irrespective of whether the inode is already set up
> (i.e. if I_NEW isn't set).
>=20
> It looks like I_NEW has been interpreted as to indicating that the
> inode is
> being created as a filesystem object (e.g. by mkdir) whereas it's
> actually
> merely about allocation and initialisation of struct inode in memory.
>=20

What do you mean by mishandling? Do you imply that Ceph has to set up
the I_NEW somehow? Is it not VFS responsibility?

Thanks,
Slava.


