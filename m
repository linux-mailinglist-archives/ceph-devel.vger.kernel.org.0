Return-Path: <ceph-devel+bounces-4126-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CBC4C9445B
	for <lists+ceph-devel@lfdr.de>; Sat, 29 Nov 2025 17:47:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C7C04345608
	for <lists+ceph-devel@lfdr.de>; Sat, 29 Nov 2025 16:47:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 803AA217F31;
	Sat, 29 Nov 2025 16:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sLZGAE7v"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6EF14A4CC
	for <ceph-devel@vger.kernel.org>; Sat, 29 Nov 2025 16:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764434868; cv=none; b=tVNTTj6Dby/PS4kYCBeUhQOzCBVzxEy0jgb9UNIOykB61EJylP6XIAybRXYm/3CBPZNmD3U5cXWV4D4y12FI1xPE7CAWnkKEzU0/L0QzVHt9qIvhMjTjhfeR+HQKiWIznPr3Vw0GU0rTIeEQ719r+R2L/XYPdnnNKIlTRmk1E5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764434868; c=relaxed/simple;
	bh=lfXocuAK/pWFxfOrTNg5yzIeqcc91Ezqf3NtrGk7lPo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b0Fsk4+br1D7RcZFDkOjOzAlaVLX5X1EM5sKjX5SXMbjIXmiqp8/6pc2xt8TkkQER+eoj/scaoFCGgOABY07wtsNXoPq6Tgozfv4Z/tu5vDsovkqK+LegRXbUYXcBUZiw76zLYwBk6Dyd/naaHJrkW3fdkZWqU4B/p/Ya54/ha8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sLZGAE7v; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-477a2ab455fso28520585e9.3
        for <ceph-devel@vger.kernel.org>; Sat, 29 Nov 2025 08:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764434865; x=1765039665; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=q3ych/iH++Burly7REfAIiFBvK9CWqovdUB/sBoH0wI=;
        b=sLZGAE7v67LEK95/OEJzyVxH4+D0Bj0RPFWN1j3Ih6DIkB1SZT1gTchXIIr2wYAEnk
         L0kWgu0FZ1jq0RzhLLdfk2RwCOAu0EVYo6zGqMmtaRvkajxAQB8O+KIE+sj018iDt0g2
         Fq23960xhDHYx7o8KhhwVQ/YswI8kA1Qeq7moUpA4qJHnFWfr93JaEjDnJGmJrn+7b8e
         emUgDglYKOjJRjf7Eb3mw6IcHp7TGxY3nniLnXLSSl0jrHh/xsUeXFTDolJm1zYdiwut
         dGfMI+dX+LlMD3vQ0ZtX9G4eGTXm8A2jbGkEcwu8FwTuL4KFf6V1hW+F7oNaUBKU0+/x
         KDQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764434865; x=1765039665;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q3ych/iH++Burly7REfAIiFBvK9CWqovdUB/sBoH0wI=;
        b=LnIXmJAPjWui/EHMyglkPf6gFxnlINQ2YHiGUuEckOulIZM9RRXwmrNUzxW9L9T2jj
         08ml3vtcdPGjqTm+CoznqZTUahXQKn5/yBIyVv0M7MFBHNPpJ1FVzScs76WiSqeeNB9C
         CwBJRVYdFA/mt52Xtm5B9MseNedOEElMbUZl/wWFptzjVzvidZYXOa6+CNlTG5/DoVtI
         mJBAih/lueFl+jLYfSVaxZaaNmC1Llokaf4V99JFGR1KGUZnE+diJu4wyjsAje1jsW/S
         Xh3PM6EqA6DMlhbR2hjo+h/TeI//v33pM0jaHGnciw4DnePJUnTQMCZo55QtssnIFWZM
         /yxQ==
X-Forwarded-Encrypted: i=1; AJvYcCWApct+JjUncng5KKaTP/rXWkj7NOAlI9M5lZfoJk3nVF7K8CYy5IRM58K1Xb51pFzBTF53o34spCRL@vger.kernel.org
X-Gm-Message-State: AOJu0Yxq4XEPizXjmZPzBrEzh5WLvXJYcLPoIltPeuwpBs+C9Xt/PCdw
	hUDWEdkeuXTvW7BEEIxJW1SDuf2sfBDelxJVrUv/MY5Y94kjEgLoHUjjVwLJFSF6Tg8=
X-Gm-Gg: ASbGncuDNE2haMtfidGZUXSl/ovi/d94rBgebf5jMWU1223HA5uoFX/0SvG9vOK0sGs
	SK+zdatSaeXui0RX/IC3TsdPLGFGagLyFy3/LTj2Pol5724M7CkClaCoWdTlhJcNysUrX8oci6K
	50GhkEWTQ6I6hnfVSMVuNLUuxa7Xc0BX9dqawNRmd4sN1Kiyu9twc3HyMjXfKUw1D7ZYqIpuGmh
	NDAqz/h39z9mAErDvNvbB0sPOpdE7VrhfnG/QpAao57RcwtRLD1i22HVbPBOAALjQbzn8N381CJ
	22LvKBnzpmQkkjg2FdhJZdEhkBSw2Yh9pqzIuXGfS4xRZ8tZvOmTR5K0vBRroatQH9ODsIm+7B8
	rc+DffuiO8K7XHIIN9z4dMxGo8pShjaD/MSV8iUVG9n77/fAmeOWf67SKK8xaywgzoY9gUfLTmw
	MwYyGN9c7gEpqp/CMOuMsmgxyr+wo=
X-Google-Smtp-Source: AGHT+IHWC/GnPcXEFcRMCb0gXQ0gjyiuDDgkjLVVLavOmK+5nIoumamUjPkBQTmCBaMvnDlVWFIUqg==
X-Received: by 2002:a05:600c:35d1:b0:477:fcb:2267 with SMTP id 5b1f17b1804b1-477c10d6e76mr367577405e9.8.1764434864537;
        Sat, 29 Nov 2025 08:47:44 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-479111438b9sm163292285e9.2.2025.11.29.08.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 08:47:43 -0800 (PST)
Date: Sat, 29 Nov 2025 19:47:40 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Alex Markuze <amarkuze@redhat.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, ceph-devel@vger.kernel.org,
	idryomov@gmail.com, linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com, Slava.Dubeyko@ibm.com
Subject: Re: [PATCH] ceph: fix potential NULL dereferenced issue in
 ceph_fill_trace()
Message-ID: <aSsjrNnuC3hHtu8F@stanley.mountain>
References: <20250827190122.74614-2-slava@dubeyko.com>
 <CAO8a2Sj1QUPbhqCYftMXC1E8+Dd=Ob+BrdTULPO7477yhkk39w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO8a2Sj1QUPbhqCYftMXC1E8+Dd=Ob+BrdTULPO7477yhkk39w@mail.gmail.com>

On Thu, Aug 28, 2025 at 12:28:15PM +0300, Alex Markuze wrote:
> Considering we hadn't seen any related issues, I would add an unlikely
> macro for that if.
> 

Using likely/unlikely() should only be done if there is a reason to
think it will affect benchmarking data.  Otherwise, you're just making
the code messy for no reason.

> On Wed, Aug 27, 2025 at 10:02 PM Viacheslav Dubeyko <slava@dubeyko.com> wrote:
> >
> > From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> >
> > The Coverity Scan service has detected a potential dereference of
> > an explicit NULL value in ceph_fill_trace() [1].
> >
> > The variable in is declared in the beggining of
> > ceph_fill_trace() [2]:
> >
> > struct inode *in = NULL;

Most of the time, these sorts of NULL initializers are just there
to silence "uninitialize variable" warnings when the code is too
complicated for GCC to parse.

> >
> > However, the initialization of the variable is happening under
> > condition [3]:
> >
> > if (rinfo->head->is_target) {
> >     <skipped>
> >     in = req->r_target_inode;
> >     <skipped>
> > }
> >
> > Potentially, if rinfo->head->is_target == FALSE, then
> > in variable continues to be NULL and later the dereference of
> > NULL value could happen in ceph_fill_trace() logic [4,5]:
> >
> > else if ((req->r_op == CEPH_MDS_OP_LOOKUPSNAP ||
> >             req->r_op == CEPH_MDS_OP_MKSNAP) &&
> >             test_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags) &&
> >              !test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags)) {
> > <skipped>
> >      ihold(in);
> >      err = splice_dentry(&req->r_dentry, in);
> >      if (err < 0)
> >          goto done;
> > }
> >
> > This patch adds the checking of in variable for NULL value
> > and it returns -EINVAL error code if it has NULL value.
> >
> > [1] https://scan5.scan.coverity.com/#/project-view/64304/10063?selectedIssue=1141197
> > [2] https://elixir.bootlin.com/linux/v6.17-rc3/source/fs/ceph/inode.c#L1522
> > [3] https://elixir.bootlin.com/linux/v6.17-rc3/source/fs/ceph/inode.c#L1629
> > [4] https://elixir.bootlin.com/linux/v6.17-rc3/source/fs/ceph/inode.c#L1745
> > [5] https://elixir.bootlin.com/linux/v6.17-rc3/source/fs/ceph/inode.c#L1777
> >
> > Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

If this is really a bug it should have a Fixes tag.

> > cc: Alex Markuze <amarkuze@redhat.com>
> > cc: Ilya Dryomov <idryomov@gmail.com>
> > cc: Ceph Development <ceph-devel@vger.kernel.org>
> > ---
> >  fs/ceph/inode.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > index fc543075b827..dee2793d822f 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -1739,6 +1739,11 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
> >                         goto done;
> >                 }

This "goto done;" is from the if (!rinfo->head->is_target) { test,
so we know

> >
> > +               if (!in) {

that this NULL check is not required.

regards,
dan carpenter

> > +                       err = -EINVAL;
> > +                       goto done;
> > +               }
> > +
> >                 /* attach proper inode */
> >                 if (d_really_is_negative(dn)) {
> >                         ceph_dir_clear_ordered(dir);
> > @@ -1774,6 +1779,12 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
> >                 doutc(cl, " linking snapped dir %p to dn %p\n", in,
> >                       req->r_dentry);
> >                 ceph_dir_clear_ordered(dir);
> > +
> > +               if (!in) {
> > +                       err = -EINVAL;
> > +                       goto done;
> > +               }
> > +
> >                 ihold(in);
> >                 err = splice_dentry(&req->r_dentry, in);
> >                 if (err < 0)
> > --
> > 2.51.0
> >
> 

