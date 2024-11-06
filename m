Return-Path: <ceph-devel+bounces-2031-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9D6F9BF81E
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Nov 2024 21:40:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A99B283EA5
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Nov 2024 20:40:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF0C120C487;
	Wed,  6 Nov 2024 20:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fvIDciQG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="L/DQSw+2";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fvIDciQG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="L/DQSw+2"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C8320C47B;
	Wed,  6 Nov 2024 20:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730925653; cv=none; b=qAM3CCHNqlTgLmeYnTYXni5PDNWFIYKjng4iWOmfgKY9GTz6+1W/99ADnBWY7sfVS+lLYst6Zsgg1dtPdw6OGBGPW5xtDsCIuCho6Gxq4ScGBE4Q5pywT9iSMxiL9T/VJVgqrJOqLoJ117at0hyPoY3yjW+zwST57S+HrUT+s+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730925653; c=relaxed/simple;
	bh=W7LCrVhBCKJDCj7yTDvNWsaAdUMN6aX+Sezbih3crWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=AmppfDaV6TZHMh8CQbcH4aVGBn3uI4EnLfDcon3s5Zx3Wfk8rG13vlNPVGQKNKQxHSLvwVmH7CjsizMxOpy9gORvWOqug7MRLumtffxb6fLmVR84k4KU+b92fEy1elRJ34CO3ANSPFup6I7gEotM4vFQANBLTI0oNYjapi8w6xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fvIDciQG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=L/DQSw+2; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fvIDciQG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=L/DQSw+2; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B8E061FB72;
	Wed,  6 Nov 2024 20:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730925649; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:  in-reply-to:in-reply-to;
	bh=3b6svSmPMRRXXayJxkjnSLgRaIEr/eGX1ESHi+OGbDg=;
	b=fvIDciQGaTPK31+bWH04VLDq/ZFKupXpGmXzuFodHkL0IkYTnO5jkWmsGVWY9LGapZYqAd
	dVy/bRdaHK1Ftgi4FUB9++LpSIBAmkTrOYm5qzqVdgPpOK5BdncLvd+/6BMszjsPA5r02m
	eCaOOYDfPyqIZSUdfGVXdu8ad9bOpcQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730925649;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:  in-reply-to:in-reply-to;
	bh=3b6svSmPMRRXXayJxkjnSLgRaIEr/eGX1ESHi+OGbDg=;
	b=L/DQSw+28RX95UrbeKydMKnscho6kXQ5pxMXFC6lfr9qWBFkgNOhh4+LYtL/9r6wCQzRV8
	URI4jwiZIn1Rg8Dw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fvIDciQG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="L/DQSw+2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730925649; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:  in-reply-to:in-reply-to;
	bh=3b6svSmPMRRXXayJxkjnSLgRaIEr/eGX1ESHi+OGbDg=;
	b=fvIDciQGaTPK31+bWH04VLDq/ZFKupXpGmXzuFodHkL0IkYTnO5jkWmsGVWY9LGapZYqAd
	dVy/bRdaHK1Ftgi4FUB9++LpSIBAmkTrOYm5qzqVdgPpOK5BdncLvd+/6BMszjsPA5r02m
	eCaOOYDfPyqIZSUdfGVXdu8ad9bOpcQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730925649;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:  in-reply-to:in-reply-to;
	bh=3b6svSmPMRRXXayJxkjnSLgRaIEr/eGX1ESHi+OGbDg=;
	b=L/DQSw+28RX95UrbeKydMKnscho6kXQ5pxMXFC6lfr9qWBFkgNOhh4+LYtL/9r6wCQzRV8
	URI4jwiZIn1Rg8Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7E620137C4;
	Wed,  6 Nov 2024 20:40:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JW/GGFHUK2f0KQAAD6G6ig
	(envelope-from <rgoldwyn@suse.de>); Wed, 06 Nov 2024 20:40:49 +0000
Date: Wed, 6 Nov 2024 15:40:44 -0500
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: Xiubo Li <xiubli@redhat.com>
Cc: "Luis Henriques (SUSE)" <luis.henriques@linux.dev>, 
	Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2] ceph: ceph: fix out-of-bound array access when
 doing a file read
Message-ID: <yvmwdvnfzqz3efyoypejvkd4ihn5viagy4co7f4pquwrlvjli6@t7k6uihd2pp3>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1c50195-07a9-4634-be01-71f4567daa54@redhat.com>
X-Rspamd-Queue-Id: B8E061FB72
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MISSING_XM_UA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[linux.dev,gmail.com,vger.kernel.org];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.01
X-Spam-Flag: NO

Hi Xiubo,

> BTW, so in the following code:
> 
> 1202                 idx = 0;
> 1203                 if (ret <= 0)
> 1204                         left = 0;
> 1205                 else if (off + ret > i_size)
> 1206                         left = i_size - off;
> 1207                 else
> 1208                         left = ret;
> 
> The 'ret' should be larger than '0', right ?
> 
> If so we do not check anf fix it in the 'else if' branch instead?
> 
> Because currently the read path code won't exit directly and keep 
> retrying to read if it found that the real content length is longer than 
> the local 'i_size'.
> 
> Again I am afraid your current fix will break the MIX filelock semantic ?

Do you think changing left to ssize_t instead of size_t will
fix the problem?


diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 4b8d59ebda00..f8955773bdd7 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1066,7 +1066,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 	if (ceph_inode_is_shutdown(inode))
 		return -EIO;
 
-	if (!len)
+	if (!len || !i_size)
 		return 0;
 	/*
 	 * flush any page cache pages in this range.  this
@@ -1087,7 +1087,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 		size_t page_off;
 		bool more;
 		int idx;
-		size_t left;
+		ssize_t left;
 		struct ceph_osd_req_op *op;
 		u64 read_off = off;
 		u64 read_len = len;

-- 
Goldwyn

