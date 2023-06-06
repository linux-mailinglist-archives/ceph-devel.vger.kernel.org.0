Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3A6723C81
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jun 2023 11:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbjFFJGA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jun 2023 05:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbjFFJFy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Jun 2023 05:05:54 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C2AF7
        for <ceph-devel@vger.kernel.org>; Tue,  6 Jun 2023 02:05:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 978DB21995;
        Tue,  6 Jun 2023 09:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686042351; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tIEQZMIVinWiqv6OSt2nM3rA8bgQXWNd685sDLdl9mI=;
        b=xurlk5QlKX8JaDND9h2VYyfWv5r0OLPOLa+jYuXD2TSeV/o0Ef4udf8cxN4Y+1btsDtS2F
        N9kczxGVUz6qI3NrRCi5j3DccCRrwSHFr5VpeCfibVuZUBQjUS9WJBNth+5p8pLWWqbrgu
        A5RH+oyjM0qSj/X8RpBiMSeKllEqdps=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686042351;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tIEQZMIVinWiqv6OSt2nM3rA8bgQXWNd685sDLdl9mI=;
        b=qV4squlZ2Ce4713HHY8XNuOsizrhS5+6K0G99QifDIg1vEig2swF6akpvLSsXN7oT6SUBc
        DCzkvi8WtdfMpvCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 25A7013776;
        Tue,  6 Jun 2023 09:05:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /n8zBu/2fmSNRgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 06 Jun 2023 09:05:51 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 6b358356;
        Tue, 6 Jun 2023 09:05:50 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Milind Changire <mchangir@redhat.com>, idryomov@gmail.com,
        ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com
Subject: Re: [PATCH v19 69/70] ceph: switch ceph_open() to use new fscrypt
 helper
References: <20230417032654.32352-1-xiubli@redhat.com>
        <20230417032654.32352-70-xiubli@redhat.com>
        <CAED=hWACph6FJwKfE-qBr9hL5NGmr9iSoKSHPsOjVxWE=4+6GQ@mail.gmail.com>
        <0d27c653-7b32-c9d2-764f-08fb82f1ca51@redhat.com>
Date:   Tue, 06 Jun 2023 10:05:50 +0100
In-Reply-To: <0d27c653-7b32-c9d2-764f-08fb82f1ca51@redhat.com> (Xiubo Li's
        message of "Tue, 6 Jun 2023 16:37:43 +0800")
Message-ID: <87zg5d7yfl.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Xiubo Li <xiubli@redhat.com> writes:

> On 6/6/23 14:25, Milind Changire wrote:
>> nit:
>> the commit title refers to ceph_open() but the code changes are
>> pertaining to ceph_lookup()
>
> Good catch.
>
> I couldn't remember why we didn't fix this before as I remembered I have =
found
> this.

Yeah, it's really odd we didn't catch this before.  I had to go look at
old email: this helper was initially used in ceph_atomic_open() only, but
then in v3 it was made more generic so that it could also be used in
ceph_lookup().

Xiubo, do you want me to send out a new version of this patch, or are you
OK simply updating the subject, using 'ceph_lookup' instead of
'ceph_open'?

Cheers,
--=20
Lu=C3=ADs


> Thanks
>
> - Xiubo
>
>
>> Otherwise it looks good to me.
>>
>> Reviewed-by: Milind Changire <mchangir@redhat.com>
>>
>> On Mon, Apr 17, 2023 at 9:03=E2=80=AFAM <xiubli@redhat.com> wrote:
>>> From: Lu=C3=ADs Henriques <lhenriques@suse.de>
>>>
>>> Instead of setting the no-key dentry in ceph_lookup(), use the new
>>> fscrypt_prepare_lookup_partial() helper.  We still need to mark the
>>> directory as incomplete if the directory was just unlocked.
>>>
>>> Tested-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
>>> Tested-by: Venky Shankar <vshankar@redhat.com>
>>> Signed-off-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>>   fs/ceph/dir.c | 13 +++++++------
>>>   1 file changed, 7 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>>> index fe48a5d26c1d..c28de23e12a1 100644
>>> --- a/fs/ceph/dir.c
>>> +++ b/fs/ceph/dir.c
>>> @@ -784,14 +784,15 @@ static struct dentry *ceph_lookup(struct inode *d=
ir, struct dentry *dentry,
>>>                  return ERR_PTR(-ENAMETOOLONG);
>>>
>>>          if (IS_ENCRYPTED(dir)) {
>>> -               err =3D ceph_fscrypt_prepare_readdir(dir);
>>> +               bool had_key =3D fscrypt_has_encryption_key(dir);
>>> +
>>> +               err =3D fscrypt_prepare_lookup_partial(dir, dentry);
>>>                  if (err < 0)
>>>                          return ERR_PTR(err);
>>> -               if (!fscrypt_has_encryption_key(dir)) {
>>> -                       spin_lock(&dentry->d_lock);
>>> -                       dentry->d_flags |=3D DCACHE_NOKEY_NAME;
>>> -                       spin_unlock(&dentry->d_lock);
>>> -               }
>>> +
>>> +               /* mark directory as incomplete if it has been unlocked=
 */
>>> +               if (!had_key && fscrypt_has_encryption_key(dir))
>>> +                       ceph_dir_clear_complete(dir);
>>>          }
>>>
>>>          /* can we conclude ENOENT locally? */
>>> --
>>> 2.39.1
>>>
>>
>
