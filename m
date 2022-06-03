Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDAAE53C74D
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Jun 2022 11:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241874AbiFCJRD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 3 Jun 2022 05:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234089AbiFCJRC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 3 Jun 2022 05:17:02 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B054E264C
        for <ceph-devel@vger.kernel.org>; Fri,  3 Jun 2022 02:16:56 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A99E421A51;
        Fri,  3 Jun 2022 09:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654247815; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9+X41wpWuYcDiVSFgbkGQv/ATkkgfab+TbAyVYger0o=;
        b=j08tFtqRasi38+eb+lwclomrAsaKltRQ88POykKRGI8MqYHzeBqYW3DN7n5Na1fduMpEfi
        /6NNmhGMbl5XiWmXJJD4WP61HaFsX8YnkEaoaBdSvfA7EOTFb0CtjUGNxfflD6xi2IMJnb
        1Gl9XcvTE0TIkUW4JnAbFCUZgI01l9w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654247815;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9+X41wpWuYcDiVSFgbkGQv/ATkkgfab+TbAyVYger0o=;
        b=VzJssx9HS+LIEoNZEgSMxMwx8BUKW94BF1TaPsmBaZy9Fo6+DdTRFn/nOTncMVVVSzAyyU
        sMc4jM8L44MRYcAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4C1D413638;
        Fri,  3 Jun 2022 09:16:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GP99D4fRmWLQAwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Fri, 03 Jun 2022 09:16:55 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 92a10a5a;
        Fri, 3 Jun 2022 09:17:35 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, xiubli@redhat.com, idryomov@gmail.com
Subject: Re: [PATCH v14 58/64] ceph: add encryption support to writepage
References: <20220427191314.222867-1-jlayton@kernel.org>
        <20220427191314.222867-59-jlayton@kernel.org>
        <5a4d4ca805797f745fb9885fcd8d8d6252db0787.camel@kernel.org>
Date:   Fri, 03 Jun 2022 10:17:35 +0100
In-Reply-To: <5a4d4ca805797f745fb9885fcd8d8d6252db0787.camel@kernel.org> (Jeff
        Layton's message of "Thu, 02 Jun 2022 12:08:28 -0400")
Message-ID: <875yli3y34.fsf@brahms.olymp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> writes:

> On Wed, 2022-04-27 at 15:13 -0400, Jeff Layton wrote:
>> Allow writepage to issue encrypted writes. Extend out the requested size
>> and offset to cover complete blocks, and then encrypt and write them to
>> the OSDs.
>>=20
>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>> ---
>>  fs/ceph/addr.c | 34 +++++++++++++++++++++++++++-------
>>  1 file changed, 27 insertions(+), 7 deletions(-)
>>=20
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index d65d431ec933..f54940fc96ee 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -586,10 +586,12 @@ static int writepage_nounlock(struct page *page, s=
truct writeback_control *wbc)
>>  	loff_t page_off =3D page_offset(page);
>>  	int err;
>>  	loff_t len =3D thp_size(page);
>> +	loff_t wlen;
>>  	struct ceph_writeback_ctl ceph_wbc;
>>  	struct ceph_osd_client *osdc =3D &fsc->client->osdc;
>>  	struct ceph_osd_request *req;
>>  	bool caching =3D ceph_is_cache_enabled(inode);
>> +	struct page *bounce_page =3D NULL;
>>=20=20
>>  	dout("writepage %p idx %lu\n", page, page->index);
>>=20=20
>> @@ -621,6 +623,8 @@ static int writepage_nounlock(struct page *page, str=
uct writeback_control *wbc)
>>=20=20
>>  	if (ceph_wbc.i_size < page_off + len)
>>  		len =3D ceph_wbc.i_size - page_off;
>> +	if (IS_ENCRYPTED(inode))
>> +		wlen =3D round_up(len, CEPH_FSCRYPT_BLOCK_SIZE);
>>=20=20
>
> The above is buggy. We're only setting "wlen" in the encrypted case. You
> would think that the compiler would catch that, but next usage of wlen
> just passes a pointer to it to another function and that cloaks the
> warning.

Yikes!  That's indeed the sort of things we got used to have compilers
complaining about.  That must have been fun to figure this out.  Nice ;-)

Cheers,
--=20
Lu=C3=ADs

>
> Fixed in the wip-fscrypt branch, but I'll hold off on re-posting the
> series in case any other new bugs turn up.
>
>>  	dout("writepage %p page %p index %lu on %llu~%llu snapc %p seq %lld\n",
>>  	     inode, page, page->index, page_off, len, snapc, snapc->seq);
>> @@ -629,24 +633,39 @@ static int writepage_nounlock(struct page *page, s=
truct writeback_control *wbc)
>>  	    CONGESTION_ON_THRESH(fsc->mount_options->congestion_kb))
>>  		fsc->write_congested =3D true;
>>=20=20
>> -	req =3D ceph_osdc_new_request(osdc, &ci->i_layout, ceph_vino(inode), p=
age_off, &len, 0, 1,
>> -				    CEPH_OSD_OP_WRITE, CEPH_OSD_FLAG_WRITE, snapc,
>> -				    ceph_wbc.truncate_seq, ceph_wbc.truncate_size,
>> -				    true);
>> +	req =3D ceph_osdc_new_request(osdc, &ci->i_layout, ceph_vino(inode),
>> +				    page_off, &wlen, 0, 1, CEPH_OSD_OP_WRITE,
>> +				    CEPH_OSD_FLAG_WRITE, snapc,
>> +				    ceph_wbc.truncate_seq,
>> +				    ceph_wbc.truncate_size, true);
>>  	if (IS_ERR(req)) {
>>  		redirty_page_for_writepage(wbc, page);
>>  		return PTR_ERR(req);
>>  	}
>>=20=20
>> +	if (wlen < len)
>> +		len =3D wlen;
>> +
>>  	set_page_writeback(page);
>>  	if (caching)
>>  		ceph_set_page_fscache(page);
>>  	ceph_fscache_write_to_cache(inode, page_off, len, caching);
>>=20=20
>> +	if (IS_ENCRYPTED(inode)) {
>> +		bounce_page =3D fscrypt_encrypt_pagecache_blocks(page, CEPH_FSCRYPT_B=
LOCK_SIZE,
>> +								0, GFP_NOFS);
>> +		if (IS_ERR(bounce_page)) {
>> +			err =3D PTR_ERR(bounce_page);
>> +			goto out;
>> +		}
>> +	}
>>  	/* it may be a short write due to an object boundary */
>>  	WARN_ON_ONCE(len > thp_size(page));
>> -	osd_req_op_extent_osd_data_pages(req, 0, &page, len, 0, false, false);
>> -	dout("writepage %llu~%llu (%llu bytes)\n", page_off, len, len);
>> +	osd_req_op_extent_osd_data_pages(req, 0,
>> +			bounce_page ? &bounce_page : &page, wlen, 0,
>> +			false, false);
>> +	dout("writepage %llu~%llu (%llu bytes, %sencrypted)\n",
>> +	     page_off, len, wlen, IS_ENCRYPTED(inode) ? "" : "not ");
>>=20=20
>>  	req->r_mtime =3D inode->i_mtime;
>>  	err =3D ceph_osdc_start_request(osdc, req, true);
>> @@ -655,7 +674,8 @@ static int writepage_nounlock(struct page *page, str=
uct writeback_control *wbc)
>>=20=20
>>  	ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
>>  				  req->r_end_latency, len, err);
>> -
>> +	fscrypt_free_bounce_page(bounce_page);
>> +out:
>>  	ceph_osdc_put_request(req);
>>  	if (err =3D=3D 0)
>>  		err =3D len;
>
> --=20
> Jeff Layton <jlayton@kernel.org>
