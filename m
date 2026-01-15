Return-Path: <ceph-devel+bounces-4432-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E970D27B85
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Jan 2026 19:43:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2754A3158F00
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Jan 2026 18:18:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43B2F3BFE2E;
	Thu, 15 Jan 2026 18:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JRqy9Oiq"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E0B346AE8
	for <ceph-devel@vger.kernel.org>; Thu, 15 Jan 2026 18:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768501071; cv=pass; b=QqZfTe2SkSyOdvKgzayTbZRFdBqcrqqxAjpux4gr1sRDzhWvJPkx9z8CdheL3QXgOSD3Be0OSicEELO+NWzYOLcvrWLCGAdCVg0hmtexxVQqMovpsvCZrUazOImTxM6sRPQgPZpEatEk7G2eMQscTlbj2jBgJaotZDQRe54uCBs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768501071; c=relaxed/simple;
	bh=lrPbqnzgCOvE5NgsFSOuHcaOEuIUQeGDqGbHFIodw8A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OoMMpfUBDwJsG/wWD0LwySsEknxAG3RgdMuHMQ6J1nuii09Xe/zPiZ89BkJk+0DZudxG0yB24qHiHFxP9ZIpUq/gy9SIJiwIlfXPEBSoWP+r11s/+76pXl05U1bil6YOyG1cSputAzro6XbIRmlYRYEWDSliMeyFiPrSP2KTZqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JRqy9Oiq; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-64b7a38f07eso1739012a12.0
        for <ceph-devel@vger.kernel.org>; Thu, 15 Jan 2026 10:17:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768501067; cv=none;
        d=google.com; s=arc-20240605;
        b=d3zpqu1zDDsK/Wlzctdz5T2TKrIWvSQoF9P2RL7Y0xFOHOI34Mmm1aI7LZ3awL3Lh3
         aUUoMMRlY3FpUrGgkXRwNlCTvwXxSwALzN6OFtNY1v2XLWfVcn0IM9nuMnQd6e+dl/K5
         kVviodAJp87GsrQ+jf53+gC3dGXwBOu3IvcfA3xYb8ig+D1M/jEwwUYglNjJ/r54usmY
         swq9aha1xGsol/gQpmEOUGUH3amtQ44b/Lw40z3jOWMRmf3Qilr94er5HIrw0/I2xUDZ
         xQLrz0UCjvhaxYAbcKtHsqah4uE9LmTaRpMnEC+7rtcXlHWF+XZeQESf86/8xzs8YnFs
         fVxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lrPbqnzgCOvE5NgsFSOuHcaOEuIUQeGDqGbHFIodw8A=;
        fh=IKx4mjSCSoXS+ejPkAn+BtwNdmVh7B/OPJwJr7IwKaU=;
        b=EzEOI6piHZR0e4lmyKff6qpagZfw029ghdxVghlY7Ao5ZH50Nuaz8a/gLqyR/hOyCV
         5LQije55MMtrA1dyQm4OptqJQSKOOb69yt3YqiMEY06sh4qrsKqFAn5fTSwuz6QtPJQh
         PKy2A4pGY8cbnwjfxI5PeGE27fJWDE/O4O9FicC/gZ9WCCoyNeSxRqRWqzm/LbMUDz2E
         bSTWG/h35EOjqoFFsc+Rs86iiFTBKdlNFEJaz/12oMRigFlJfYVWLm6FMkVUF0Pz848T
         +3kiGu4FCJSrEAG/XrUyHbT6wPOv0bHzuvqPXbCIIAiFR+78835nMn1Ej45ONjNTSVkM
         1Zqw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768501067; x=1769105867; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lrPbqnzgCOvE5NgsFSOuHcaOEuIUQeGDqGbHFIodw8A=;
        b=JRqy9OiqbHt3NQq3XCkGStTAlcxglCMEMq+vkPdztBR4c+MkrffxyXlppZJ7bL4sv3
         +FXHo4WCeS6ifCEJXW+UdjZqdayxLi0mNMYJfj32IOulawR+3uE9C6Ut2x3X5eVTlY8+
         6iRo29sMNevgrrtfjtiRzEF0k4plHYlK2kgxZb4KZPdGjfbpVgT/wXn6hxIwTOtPADbq
         2v6VOk25RJEEoHnf4r5a+RfNediJCsI/4TTnPiMJgJQLHdyofqjBzPnr34u+fCoLT989
         FV5CVbIQ4AFknrnsxqTVaClS78Bq+9klbvidUC90tZ/EK9JmXeohHKVG3ipODkA8GlnY
         LSvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768501067; x=1769105867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lrPbqnzgCOvE5NgsFSOuHcaOEuIUQeGDqGbHFIodw8A=;
        b=AnXhm92WZ1BpG91oia6h60LamyG2B5VsUlnoY/n0g0NFaR9mFbpgpfq0jnlhFh1Yzt
         85uA3zYLuKki6ZSwwN3RFUyE0hss454rL457/K81AM5TVgHg2cfdeagTKhPY+eRdagNI
         PllcRVs1XGwJFLrhlVfsxmXKrSXRbfZspL+yZkZftM0pCW7eDUfK1wfIqcXhQj9JJ/FT
         /Kd5pTL9WYG/01b6DUvhF3QcrzpCAs8QTNLIkNgeCPnoUb7dBiuqDww053ASjCsjTZzd
         4124TpIyIWDZuY+VUfQPltcGKD4sqcQGJP/Ef1lqM6MN/8feTk/gcY2oWR66De3PBmua
         Kb/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWA2HaqmCCYGUh6kZMp4hVcTO7JRYetighNM5RDjA1Hs1A45DY3mfpnox9tG+c4tZ5wlYP+VnHfdV3H@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/ISEya9TwXeGL5T8K/AXssevzpt/WKqt2kPw+6wxlaie0IQ8D
	Fu6xQqnnTJfX62aI/1SvjMp9+u6q8lS2W+ozVDieiSQCJR5eYVyaOj4ReNr2vkk9PvNcMqCA8eh
	phPb/p+pJI9Pyaahn/MiF4p9IlwCjRzc=
X-Gm-Gg: AY/fxX4WvbP+aUZs+nfVWcIboWge3NAkzhHkKWiY6iHH9LBXs55P1KS3NF0nUWGG7dp
	YqSajCXa1zSEjrg3JCyBpDUpl7o51p5XAdO+/wRHr5ip5V4OfnbT20zJJtyxYAPF+TwtGWko3N9
	cFq3Ze0xLnqlWZVKUm5oN/Y8GclqNw7OYCNHcBy7hKGK0ep2sngueD+TerEEA6kFZvIMTeKIX1h
	EcCmZDvNh3LOklgPJ+nmBbuKwhB7M9E3he1cA8ODUQSThxK49UfrUDskZYM7+gi3FvQ/2QJWmCI
	p3cYiWJzxLp6E7nwGudWX/n8VYOmwg==
X-Received: by 2002:a05:6402:510f:b0:64b:7eba:39ed with SMTP id
 4fb4d7f45d1cf-654525ccad4mr346097a12.13.1768501066374; Thu, 15 Jan 2026
 10:17:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
In-Reply-To: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 15 Jan 2026 19:17:35 +0100
X-Gm-Features: AZwV_QjhT3ZtgvkbHJB7796GEklGCbcNDL5CeRwrn_YYeN3X8FqPO-3_iRnRORw
Message-ID: <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Carlos Maiolino <cem@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
	Andreas Gruenbacher <agruenba@redhat.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, 
	devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2026 at 6:48=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> In recent years, a number of filesystems that can't present stable
> filehandles have grown struct export_operations. They've mostly done
> this for local use-cases (enabling open_by_handle_at() and the like).
> Unfortunately, having export_operations is generally sufficient to make
> a filesystem be considered exportable via nfsd, but that requires that
> the server present stable filehandles.

Where does the term "stable file handles" come from? and what does it mean?
Why not "persistent handles", which is described in NFS and SMB specs?

Not to mention that EXPORT_OP_PERSISTENT_HANDLES was Acked
by both Christoph and Christian:

https://lore.kernel.org/linux-fsdevel/20260115-rundgang-leihgabe-12018e93c0=
0c@brauner/

Am I missing anything?

Thanks,
Amir.

