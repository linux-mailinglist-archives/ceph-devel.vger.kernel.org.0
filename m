Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7985E4ED740
	for <lists+ceph-devel@lfdr.de>; Thu, 31 Mar 2022 11:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234281AbiCaJu1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 31 Mar 2022 05:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbiCaJu0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 31 Mar 2022 05:50:26 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B549148316
        for <ceph-devel@vger.kernel.org>; Thu, 31 Mar 2022 02:48:39 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6F04A210F1;
        Thu, 31 Mar 2022 09:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1648720118; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y6NLTY++++8QWA+/LJ6ZW1/OUFDQdp/G+pDQOSPum3U=;
        b=ZcFLXSxtad06LWvgBvap37k0t05o029IlBJFPmHCT7Vfb1TBAN4JGrR0+Pkc4emQyU/AJp
        cOG1PBrg5kEMNOS8lgpdu0Xw6avLtDqS74OjG/xVD6d2fOe4j9rUVV8AYmpI7HbOgZGg39
        5qZQPcWSd3Hq+TttALRMKUypMilZh2Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1648720118;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y6NLTY++++8QWA+/LJ6ZW1/OUFDQdp/G+pDQOSPum3U=;
        b=pBfonsQ2Acw575BlyDYK1c/fdq2tMztNcZ8yVN+lhrifkfm/BY52xjznHtVNMNa/Mg58ra
        CDxDM1W4UyTJldBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1F3C0132DC;
        Thu, 31 Mar 2022 09:48:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /xadBPZ4RWISRQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 31 Mar 2022 09:48:38 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 0117b915;
        Thu, 31 Mar 2022 09:49:00 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH] ceph: discard r_new_inode if open O_CREAT opened
 existing inode
References: <20220330190457.73279-1-jlayton@kernel.org>
        <7cb4898491f262fd1ecf411f055a00927ebc13b4.camel@kernel.org>
Date:   Thu, 31 Mar 2022 10:49:00 +0100
In-Reply-To: <7cb4898491f262fd1ecf411f055a00927ebc13b4.camel@kernel.org> (Jeff
        Layton's message of "Wed, 30 Mar 2022 15:13:09 -0400")
Message-ID: <87y20qpi43.fsf@brahms.olymp>
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

> On Wed, 2022-03-30 at 15:04 -0400, Jeff Layton wrote:
>> When we do an unchecked create, we optimistically pre-create an inode
>> and populate it, including its fscrypt context. It's possible though
>> that we'll end up opening an existing inode, in which case the
>> precreated inode will have a crypto context that doesn't match the
>> existing data.
>>=20
>> If we're issuing an O_CREAT open and find an existing inode, just
>> discard the precreated inode and create a new one to ensure the context
>> is properly set.
>>=20
>> Cc: Lu=C3=ADs Henriques <lhenriques@suse.de>
>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>> ---
>>  fs/ceph/mds_client.c | 10 ++++++++--
>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 840a60b812fc..b03128fdbb07 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -3504,13 +3504,19 @@ static void handle_reply(struct ceph_mds_session=
 *session, struct ceph_msg *msg)
>>  	/* Must find target inode outside of mutexes to avoid deadlocks */
>>  	rinfo =3D &req->r_reply_info;
>>  	if ((err >=3D 0) && rinfo->head->is_target) {
>> -		struct inode *in;
>> +		struct inode *in =3D xchg(&req->r_new_inode, NULL);
>>  		struct ceph_vino tvino =3D {
>>  			.ino  =3D le64_to_cpu(rinfo->targeti.in->ino),
>>  			.snap =3D le64_to_cpu(rinfo->targeti.in->snapid)
>>  		};
>>=20=20
>> -		in =3D ceph_get_inode(mdsc->fsc->sb, tvino, xchg(&req->r_new_inode, N=
ULL));
>> +		/* If we ended up opening an existing inode, discard r_new_inode */
>> +		if (req->r_op =3D=3D CEPH_MDS_OP_CREATE && !req->r_reply_info.has_cre=
ate_ino) {
>> +			iput(in);
>> +			in =3D NULL;
>> +		}
>> +
>> +		in =3D ceph_get_inode(mdsc->fsc->sb, tvino, in);
>>  		if (IS_ERR(in)) {
>>  			err =3D PTR_ERR(in);
>>  			mutex_lock(&session->s_mutex);
>
> Forgot to mention that this one is for the fscrypt pile. This patch
> fixes generic/595 for me.

Wow!  I must say it: the issue is very far from the places I was looking
at.  Thanks!

Reviewed-and-tested-by: Lu=C3=ADs Henriques <lhenriques@suse.de>

Cheers,
--=20
Lu=C3=ADs
