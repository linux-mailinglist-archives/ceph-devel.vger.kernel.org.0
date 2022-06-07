Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9CB5403F1
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jun 2022 18:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344047AbiFGQkr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jun 2022 12:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245131AbiFGQkq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jun 2022 12:40:46 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E302CC9641
        for <ceph-devel@vger.kernel.org>; Tue,  7 Jun 2022 09:40:45 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 984B21F989;
        Tue,  7 Jun 2022 16:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654620044; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MUfwH7tVyUy4ukwu+59C99uTIyjdiapIigZlzei8HZU=;
        b=fDXoic52b86QjDYWkhJmDOQn9GU5IDYSMrHMU2WsVqUno246UQm+cl+QeHYqmaB7zQkIeA
        9coCw54YjFvn26ApRvfv2cj2RXQTfpdbGRsJ7r3bPmoUftmC9yDh0+Z9K1+TE63mc6wFwE
        eLzdI9RFYLtW41HCytc4bnGTJXSfjBk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654620044;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MUfwH7tVyUy4ukwu+59C99uTIyjdiapIigZlzei8HZU=;
        b=zqtDjM5nnxBQUhcypYfAjnnjXY68bze5/ZWglykPrL0wNfSJMKRWR2QnSrMyBra2ogsbCz
        jcMJ7v5py8euXZBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4D75713638;
        Tue,  7 Jun 2022 16:40:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uiKhD4x/n2K5fgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 07 Jun 2022 16:40:44 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 71642313;
        Tue, 7 Jun 2022 16:41:25 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org
Subject: Re: [PATCH] ceph: don't implement writepage
References: <20220607112703.17997-1-jlayton@kernel.org>
Date:   Tue, 07 Jun 2022 17:41:25 +0100
In-Reply-To: <20220607112703.17997-1-jlayton@kernel.org> (Jeff Layton's
        message of "Tue, 7 Jun 2022 07:27:03 -0400")
Message-ID: <87sfog8lze.fsf@brahms.olymp>
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

> Remove ceph_writepage as it's not strictly required these days.
>
> To quote from commit 21b4ee7029c9 (xfs: drop ->writepage completely):
>
>     ->writepage is only used in one place - single page writeback from
>     memory reclaim. We only allow such writeback from kswapd, not from
>     direct memory reclaim, and so it is rarely used. When it comes from
>     kswapd, it is effectively random dirty page shoot-down, which is
>     horrible for IO patterns. We will already have background writeback
>     trying to clean all the dirty pages in memory as efficiently as
>     possible, so having kswapd interrupt our well formed IO stream only
>     slows things down. So get rid of xfs_vm_writepage() completely.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/addr.c | 25 -------------------------
>  1 file changed, 25 deletions(-)

The diffstat in particular looks great ;-)

Reviewed-by: Lu=C3=ADs Henriques <lhenriques@suse.de>

Cheers
--=20
Lu=C3=ADs


>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 40830cb9b599..3489444c55b9 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -680,30 +680,6 @@ static int writepage_nounlock(struct page *page, str=
uct writeback_control *wbc)
>  	return err;
>  }
>=20=20
> -static int ceph_writepage(struct page *page, struct writeback_control *w=
bc)
> -{
> -	int err;
> -	struct inode *inode =3D page->mapping->host;
> -	BUG_ON(!inode);
> -	ihold(inode);
> -
> -	if (wbc->sync_mode =3D=3D WB_SYNC_NONE &&
> -	    ceph_inode_to_client(inode)->write_congested)
> -		return AOP_WRITEPAGE_ACTIVATE;
> -
> -	wait_on_page_fscache(page);
> -
> -	err =3D writepage_nounlock(page, wbc);
> -	if (err =3D=3D -ERESTARTSYS) {
> -		/* direct memory reclaimer was killed by SIGKILL. return 0
> -		 * to prevent caller from setting mapping/page error */
> -		err =3D 0;
> -	}
> -	unlock_page(page);
> -	iput(inode);
> -	return err;
> -}
> -
>  /*
>   * async writeback completion handler.
>   *
> @@ -1394,7 +1370,6 @@ static int ceph_write_end(struct file *file, struct=
 address_space *mapping,
>  const struct address_space_operations ceph_aops =3D {
>  	.readpage =3D netfs_readpage,
>  	.readahead =3D netfs_readahead,
> -	.writepage =3D ceph_writepage,
>  	.writepages =3D ceph_writepages_start,
>  	.write_begin =3D ceph_write_begin,
>  	.write_end =3D ceph_write_end,
> --=20
>
> 2.36.1
>
