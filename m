Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD3C76B02E2
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Mar 2023 10:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjCHJ33 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Mar 2023 04:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjCHJ32 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Mar 2023 04:29:28 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C75A02AA
        for <ceph-devel@vger.kernel.org>; Wed,  8 Mar 2023 01:29:26 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6E1121F383;
        Wed,  8 Mar 2023 09:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678267765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5BSgSFWh7npYrnDr95OzVtJVa8L8u+LCKos1wk+sAIs=;
        b=Vyh9NTdM54O01kPMT4wYtHgjXbTMRnJTgG05izp8CLgITWGZfA50iGqI1YlGw/hkhqTPZd
        Mae6FRhxvLUKQkZpVxBjD872WSezcitDeD/W0B+OBKReAVUIILYUKWNI+Htk74c5+URLcY
        b+OhyiJjjW7BWX73z0ws2ZuI72V+0E8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678267765;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5BSgSFWh7npYrnDr95OzVtJVa8L8u+LCKos1wk+sAIs=;
        b=H07CIu16ToirRwEQb9FvqyOE5j+UOFqJN6F2seNagl6r2Y4/T197697h1y0KObANmeVcpf
        yut7xiKZmZQKcGCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0A7291348D;
        Wed,  8 Mar 2023 09:29:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id YUbdOnRVCGQVOwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 08 Mar 2023 09:29:24 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 98749961;
        Wed, 8 Mar 2023 09:29:24 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com
Subject: Re: [PATCH v16 25/68] ceph: make d_revalidate call fscrypt
 revalidator for encrypted dentries
References: <20230227032813.337906-1-xiubli@redhat.com>
        <20230227032813.337906-26-xiubli@redhat.com> <87o7p48kby.fsf@suse.de>
        <72e7b6cc-ba6b-796e-2ff6-1e8ff2ac7eee@redhat.com>
Date:   Wed, 08 Mar 2023 09:29:24 +0000
In-Reply-To: <72e7b6cc-ba6b-796e-2ff6-1e8ff2ac7eee@redhat.com> (Xiubo Li's
        message of "Wed, 8 Mar 2023 09:50:40 +0800")
Message-ID: <87jzzr8ubv.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Xiubo Li <xiubli@redhat.com> writes:

> On 08/03/2023 02:53, Lu=C3=ADs Henriques wrote:
>> xiubli@redhat.com writes:
>>
>>> From: Jeff Layton <jlayton@kernel.org>
>>>
>>> If we have a dentry which represents a no-key name, then we need to test
>>> whether the parent directory's encryption key has since been added.  Do
>>> that before we test anything else about the dentry.
>>>
>>> Reviewed-by: Xiubo Li <xiubli@redhat.com>
>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>> ---
>>>   fs/ceph/dir.c | 8 ++++++--
>>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>>> index d3c2853bb0f1..5ead9f59e693 100644
>>> --- a/fs/ceph/dir.c
>>> +++ b/fs/ceph/dir.c
>>> @@ -1770,6 +1770,10 @@ static int ceph_d_revalidate(struct dentry *dent=
ry, unsigned int flags)
>>>   	struct inode *dir, *inode;
>>>   	struct ceph_mds_client *mdsc;
>>>   +	valid =3D fscrypt_d_revalidate(dentry, flags);
>>> +	if (valid <=3D 0)
>>> +		return valid;
>>> +
>> This patch has confused me in the past, and today I found myself
>> scratching my head again looking at it.
>>
>> So, I've started seeing generic/123 test failing when running it with
>> test_dummy_encryption.  I was almost sure that this test used to run fine
>> before, but I couldn't find any evidence (somehow I lost my old testing
>> logs...).
>>
>> Anyway, the test is quite simple:
>>
>> 1. Creates a directory with write permissions for root only
>> 2. Writes into a file in that directory
>> 3. Uses 'su' to try to modify that file as a different user, and
>>     gets -EPERM
>>
>> All these steps run fine, and the test should pass.  *However*, in the
>> test cleanup function, a simple 'rm -rf <dir>' will fail with -ENOTEMPTY.
>> 'strace' shows that calling unlinkat() to remove the file got a '-ENOENT'
>> and then -ENOTEMPTY for the directory.
>>
>> Some digging allowed me to figure out that running commands with 'su' wi=
ll
>> drop caches (I see 'su (874): drop_caches: 2' in the log).  And this is
>> how I ended up looking at this patch.  fscrypt_d_revalidate() will return
>> '0' if the parent directory does has a key (fscrypt_has_encryption_key()=
).
>> Can we really say here that the dentry is *not* valid in that case?  Or
>> should that '<=3D 0' be a '< 0'?
>>
>> (But again, this patch has confused me before...)
>
> Luis,
>
> Could you reproduce it with the latest testing branch ?

Yes, I'm seeing this with the latest code.

> I never seen the generic/123 failure yet. And just now I ran the test for=
 many
> times locally it worked fine.

That's odd.  With 'test_dummy_encryption' mount option I can reproduce it
every time.

> From the generic/123 test code it will never touch the key while testing,=
 that
> means the dentries under the test dir will always have the keyed name. An=
d then
> the 'fscrypt_d_revalidate()' should return 1 always.
>
> Only when we remove the key will it trigger evicting the inodes and then =
when we
> add the key back will the 'fscrypt_d_revalidate()' return 0 by checking t=
he
> 'fscrypt_has_encryption_key()'.
>
> As I remembered we have one or more fixes about this those days, not sure
> whether you were hitting those bugs we have already fixed ?

Yeah, I remember now, and I guess there's yet another one here!

I'll look closer into this and see if I can find out something else.  I'm
definitely seeing 'fscrypt_d_revalidate()' returning 0, so probably the
bug is in the error paths, when the 'fsgqa' user tries to write into the
file.

Thanks for your feedback, Xiubo.

Cheers,
--=20
Lu=C3=ADs
