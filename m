Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1646F4443A2
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Nov 2021 15:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhKCOfP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Nov 2021 10:35:15 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:52924 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbhKCOfJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Nov 2021 10:35:09 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id EA5401F782;
        Wed,  3 Nov 2021 14:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635949952; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7PAwFld5AMTtIqqJ8gCcKM0Tly40cjofB0Vk5ZWjYCg=;
        b=X39agvfWyCB3jR1Jz3VaE0gegdlXKp2uoVYRFtKxq4EXo5BG4TghnJ947E/O1fC9yf7wto
        wLmP73MVpVf21aGPAWnboRvDsrDrOIWEOfYopysCAPXY+lCR8yiwAr2BJZhcRfLdvg3mVp
        fCobFsgwgPcVNyAe+tCElVyAboJtW98=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635949952;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7PAwFld5AMTtIqqJ8gCcKM0Tly40cjofB0Vk5ZWjYCg=;
        b=YjTxjzOSdmzgJuDOpx6jZS3UaBGEE4OXyo0RVIuG0KhDV9V5ZIRtakkHgEiN4nz6DQBRNH
        kC0lpa4ipcGujiCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8943B13E03;
        Wed,  3 Nov 2021 14:32:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id hMF+Hn+dgmHcGAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 03 Nov 2021 14:32:31 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 0859eae5;
        Wed, 3 Nov 2021 14:32:30 +0000 (UTC)
Date:   Wed, 3 Nov 2021 14:32:30 +0000
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] libceph: have ceph_osdc_copy_from() return the osd
 request
Message-ID: <YYKdfvmeqP98Tjno@suse.de>
References: <20211103112405.8733-1-lhenriques@suse.de>
 <20211103112405.8733-2-lhenriques@suse.de>
 <597ab2ed71c04327d22e80ef3e630d6f0515c7b7.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <597ab2ed71c04327d22e80ef3e630d6f0515c7b7.camel@kernel.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Nov 03, 2021 at 09:06:31AM -0400, Jeff Layton wrote:
<...>
> > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > index ff8624a7c964..78384b431748 100644
> > --- a/net/ceph/osd_client.c
> > +++ b/net/ceph/osd_client.c
> > @@ -5347,23 +5347,24 @@ static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
> >  	return 0;
> >  }
> >  
> > -int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
> > -			u64 src_snapid, u64 src_version,
> > -			struct ceph_object_id *src_oid,
> > -			struct ceph_object_locator *src_oloc,
> > -			u32 src_fadvise_flags,
> > -			struct ceph_object_id *dst_oid,
> > -			struct ceph_object_locator *dst_oloc,
> > -			u32 dst_fadvise_flags,
> > -			u32 truncate_seq, u64 truncate_size,
> > -			u8 copy_from_flags)
> > +struct ceph_osd_request *
> > +ceph_osdc_copy_from(struct ceph_osd_client *osdc,
> > +		    u64 src_snapid, u64 src_version,
> > +		    struct ceph_object_id *src_oid,
> > +		    struct ceph_object_locator *src_oloc,
> > +		    u32 src_fadvise_flags,
> > +		    struct ceph_object_id *dst_oid,
> > +		    struct ceph_object_locator *dst_oloc,
> > +		    u32 dst_fadvise_flags,
> > +		    u32 truncate_seq, u64 truncate_size,
> > +		    u8 copy_from_flags)
> >  {
> >  	struct ceph_osd_request *req;
> >  	int ret;
> >  
> >  	req = ceph_osdc_alloc_request(osdc, NULL, 1, false, GFP_KERNEL);
> >  	if (!req)
> > -		return -ENOMEM;
> > +		return ERR_PTR(-ENOMEM);
> >  
> >  	req->r_flags = CEPH_OSD_FLAG_WRITE;
> >  
> > @@ -5382,11 +5383,11 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
> >  		goto out;
> >  
> >  	ceph_osdc_start_request(osdc, req, false);
> > -	ret = ceph_osdc_wait_request(osdc, req);
> > +	return req;
> >  
> 
> I don't really understand why this function is part of net/ceph. It's
> odd in that it basically allocates, initializes and starts the request
> and then passes back the pointer to it. That doesn't really follow the
> pattern of the other OSD READ/WRITE ops, where we basically set them up
> and start them more directly from the fs/ceph code.
> 
> I think it'd make more sense to just get rid of ceph_osdc_copy_from
> altogether, export the osd_req_op_copy_from_init symbol and open-code
> the whole thing in ceph_do_objects_copy. This isn't otherwise called
> from rbd or anything else so I don't see the benefit of keeping this
> function as part of libceph.

At the time ceph_osdc_copy_from() was implemented, it looked like
something that would make sense to keep on the osd client code, and
eventually useful for rbd too.  But since that didn't happen, this patch
shows that it makes sense to just move the code.  So, yeah, sure.  I'll do
that.  Thanks.

Cheers,
--
Luís
