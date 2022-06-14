Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC27D54ABE3
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Jun 2022 10:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240242AbiFNIgR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Jun 2022 04:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239270AbiFNIgQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 14 Jun 2022 04:36:16 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBF73DA55
        for <ceph-devel@vger.kernel.org>; Tue, 14 Jun 2022 01:36:15 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 789FD1F460;
        Tue, 14 Jun 2022 08:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655195774; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9MHUJu85Z1Ed+phjAmZyXVLXie6iKO02hydJ31wriak=;
        b=q8+FmsqydEGLnfykYQ03KoZ/8lsp1KhMro/A9khhHNkdLOwXb+RXNdPkvx65Rr13oMY+6z
        fvo8qA2Na8F4WyhmcwG5CZFwHvw+NpxYWW4wTKrqpcbksZ8Li+0xkCgqD4N5gTN6TdIO4y
        IqdjtTSLWb1GMtJgWhAcZ4ZpFQyub9U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655195774;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9MHUJu85Z1Ed+phjAmZyXVLXie6iKO02hydJ31wriak=;
        b=/eeAT1IgOU2yzxqWu5R/h3RxgszNEh3dPgqW/99jrFKjWu3/e+DVmd1cV63KkOBkqTRJbo
        gfwsvze87Ff1ixCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0A0B31361C;
        Tue, 14 Jun 2022 08:36:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id rE06O31IqGJPIgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 14 Jun 2022 08:36:13 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 6827562f;
        Tue, 14 Jun 2022 08:36:57 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] ceph: update the auth cap when the async create req
 is forwarded
References: <20220610043140.642501-1-xiubli@redhat.com>
        <20220610043140.642501-3-xiubli@redhat.com>
        <87r13seed5.fsf@brahms.olymp>
        <4eb44a0b-f7e9-683d-8317-15cf959a570a@redhat.com>
Date:   Tue, 14 Jun 2022 09:36:57 +0100
In-Reply-To: <4eb44a0b-f7e9-683d-8317-15cf959a570a@redhat.com> (Xiubo Li's
        message of "Tue, 14 Jun 2022 08:55:04 +0800")
Message-ID: <87mtef63py.fsf@brahms.olymp>
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

Xiubo Li <xiubli@redhat.com> writes:

> On 6/14/22 12:07 AM, Lu=C3=ADs Henriques wrote:
>> Xiubo Li <xiubli@redhat.com> writes:
>>
>>> For async create we will always try to choose the auth MDS of frag
>>> the dentry belonged to of the parent directory to send the request
>>> and ususally this works fine, but if the MDS migrated the directory
>>> to another MDS before it could be handled the request will be
>>> forwarded. And then the auth cap will be changed.
>>>
>>> We need to update the auth cap in this case before the request is
>>> forwarded.
>>>
>>> URL: https://tracker.ceph.com/issues/55857
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>>   fs/ceph/file.c       | 12 +++++++++
>>>   fs/ceph/mds_client.c | 58 ++++++++++++++++++++++++++++++++++++++++++++
>>>   fs/ceph/super.h      |  2 ++
>>>   3 files changed, 72 insertions(+)
>>>
>>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>>> index 0e82a1c383ca..54acf76c5e9b 100644
>>> --- a/fs/ceph/file.c
>>> +++ b/fs/ceph/file.c
>>> @@ -613,6 +613,7 @@ static int ceph_finish_async_create(struct inode *d=
ir, struct inode *inode,
>>>   	struct ceph_mds_reply_inode in =3D { };
>>>   	struct ceph_mds_reply_info_in iinfo =3D { .in =3D &in };
>>>   	struct ceph_inode_info *ci =3D ceph_inode(dir);
>>> +	struct ceph_dentry_info *di =3D ceph_dentry(dentry);
>>>   	struct timespec64 now;
>>>   	struct ceph_string *pool_ns;
>>>   	struct ceph_mds_client *mdsc =3D ceph_sb_to_mdsc(dir->i_sb);
>>> @@ -709,6 +710,12 @@ static int ceph_finish_async_create(struct inode *=
dir, struct inode *inode,
>>>   		file->f_mode |=3D FMODE_CREATED;
>>>   		ret =3D finish_open(file, dentry, ceph_open);
>>>   	}
>>> +
>>> +	spin_lock(&dentry->d_lock);
>>> +	di->flags &=3D ~CEPH_DENTRY_ASYNC_CREATE;
>>> +	wake_up_bit(&di->flags, CEPH_DENTRY_ASYNC_CREATE_BIT);
>>> +	spin_unlock(&dentry->d_lock);
>> Question: shouldn't we initialise 'di' *after* grabbing ->d_lock?  Ceph
>> code doesn't seem to be consistent with this regard, but my understanding
>> is that doing it this way is racy.  And if so, some other places may need
>> fixing.
>
> Yeah, it should be.
>
> BTW, do you mean some where like this:
>
> if (!test_bit(CEPH_DENTRY_ASYNC_UNLINK_BIT, &di->flags))
>
> ?
>
> If so, it's okay and no issue here.

No, I meant patterns like the one above, where you initialize a pointer to
a struct ceph_dentry_info (from ->d_fsdata) and then grab ->d_lock.  For
example, in splice_dentry().  I think there are a few other places where
this pattern can be seen, even in other filesystems.  So maybe it's not
really an issue, and that's why I asked: does this lock really protects
accesses to ->d_fsdata?

Cheers,
--=20
Lu=C3=ADs
