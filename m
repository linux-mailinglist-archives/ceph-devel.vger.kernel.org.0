Return-Path: <ceph-devel+bounces-2552-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C58EA1A236
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Jan 2025 11:52:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2F9D77A5C4E
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Jan 2025 10:52:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5589A20DD7B;
	Thu, 23 Jan 2025 10:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="U3V3zBmQ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7595420DD64
	for <ceph-devel@vger.kernel.org>; Thu, 23 Jan 2025 10:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737629522; cv=none; b=mtAOOz/za6CUpSr3p4PC3ubjjEoJSXaEkwqvjNUsAqcPLNzGt3tbVMQxolIKuuQnluE5KxTzyVpZ5KB/eVMxdZM00P70QTJoz2tO6HUPOFLt1O/W6Eyjgk4KXGWkkT2xOIHXnR8tfWFpAKzzi73ee7g5m8oMzMtf5ZrnGu8AfKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737629522; c=relaxed/simple;
	bh=64ZBKi3fVrhSq4jQLlJiPHRsTHqirJcl7b5Uyt/7Vj8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oRjItc3760N+UOHEN68VpfRxqAIPEwFYzQJkwUJnrblTZbU3g32mPHGpgMU7XJKSseYtsa6h4lZXFtQODdABynuftwBFJTuD9Lv0kE8pwfPRB7CLLnVNWecmobQe5Bh1nfn+xMuefqmNwteJTbg5dOqQYN82Niirioo9B+xAKtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=U3V3zBmQ; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4679eacf25cso4561841cf.3
        for <ceph-devel@vger.kernel.org>; Thu, 23 Jan 2025 02:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1737629518; x=1738234318; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=64ZBKi3fVrhSq4jQLlJiPHRsTHqirJcl7b5Uyt/7Vj8=;
        b=U3V3zBmQHOTOpVC7or+WO2kDmdiy1umbmtyf9HzbO9ZB3abrNB9/u9geByO9JgSc2b
         zF7iE4v41JOvOfTkwMpBJDHshs7W+3h0P9qz634hVaxkzP08wB9Q60hGe66gvDlmPDV6
         nL93y/R9E+77hrxXFDiuOmzAIp1rzsH6/LRG4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737629518; x=1738234318;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=64ZBKi3fVrhSq4jQLlJiPHRsTHqirJcl7b5Uyt/7Vj8=;
        b=Lnrj3UT3NcQe9Dj9d73gurFdeEW5lWBypxs05/+mxNU8EPKC16Z3MwERhu9PBydepo
         wUgyvJU/KEYQMFgvdT3m6LhXsUy/R7+e01rYkoULHpAk9Y9W7v6sl8x+/Jk6taRDU+W3
         tFo1N+N09uWeWsvYpdUmVrVEN73asGhPs5cLMvZ9n47V/mJJbpteB+HBxg6Fuo9+uOnp
         M86JP2CU69S6sZFkcFjSgu7wbV1JwOwQl1gdfDJPPK6xqC/9XVRIzQuzFRwBkRQp61NB
         dYRKEG0qeJMN4yFsXheqkehhdREKdFNc3jnbNo0UpzhQEdNRKiEVOZTD69wWb7ZBou3p
         rd9w==
X-Forwarded-Encrypted: i=1; AJvYcCUZgXqq38h9c/YcQkh/g/6L0Bb92O9cBaIaaeOj/KR5f4o18IXCoKOM5XZB/2jPqvUzUvIewgoYCz9n@vger.kernel.org
X-Gm-Message-State: AOJu0YyN5mpQ48TQD/xTO0IrrsQJkqfDEdANLclZZTfLuc5R9s95Yr31
	SsaNH2r8YXS4sFflZkWp7fJ3Etk4GS3EH8zX9W5ODbdyjXLOU04T4bnUN0Hyl4177yinRv1sQgg
	RbWZ+PomVA57a0h8cBP3PpFxs76QrdG0LjVVp4g==
X-Gm-Gg: ASbGncuGBmbtmH2yKvNN8LyR1v05xfhO7Uweb5DooFtrZssZiCU6yoeIjfd2Z3rqNmo
	RYQZy3xdW9tsFPTZGOtedyg6FEGscFjySAPMdanuLDwppRBfliC/f7T/+9SRu
X-Google-Smtp-Source: AGHT+IFCQv++QsFYdqvxqu76Xx1xUMCKFnqfO8lf/2kvforDl+fXpZU9BR8rgm0yfLlAmV0bkMzjZHDetx/fmDmECiM=
X-Received: by 2002:a05:622a:1986:b0:467:76cc:622d with SMTP id
 d75a77b69052e-46e12a1ca9amr403239251cf.11.1737629518280; Thu, 23 Jan 2025
 02:51:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250123014511.GA1962481@ZenIV> <20250123014643.1964371-1-viro@zeniv.linux.org.uk>
 <20250123014643.1964371-14-viro@zeniv.linux.org.uk>
In-Reply-To: <20250123014643.1964371-14-viro@zeniv.linux.org.uk>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 23 Jan 2025 11:51:47 +0100
X-Gm-Features: AbW1kvYw7DfXtx9K2u0kuT28cS6RFX0PZCipXj87ydRxCQYYo5Hopzm-X6v7khg
Message-ID: <CAJfpegvCUt3uUbbe4Y_-OHUYxP1xdgEE7F+3ecNFU-o0wh_aUQ@mail.gmail.com>
Subject: Re: [PATCH v3 14/20] fuse_dentry_revalidate(): use stable parent
 inode and name passed by caller
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, agruenba@redhat.com, amir73il@gmail.com, 
	brauner@kernel.org, ceph-devel@vger.kernel.org, dhowells@redhat.com, 
	hubcap@omnibond.com, jack@suse.cz, krisman@kernel.org, 
	linux-nfs@vger.kernel.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 23 Jan 2025 at 02:46, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> No need to mess with dget_parent() for the former; for the latter we really should
> not rely upon ->d_name.name remaining stable - it's a real-life UAF.
>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Miklos Szeredi <mszeredi@redhat.com>

