Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272094CBAB1
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Mar 2022 10:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbiCCJvH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Mar 2022 04:51:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiCCJvG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 3 Mar 2022 04:51:06 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AEB417924F
        for <ceph-devel@vger.kernel.org>; Thu,  3 Mar 2022 01:50:20 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 239431F37E;
        Thu,  3 Mar 2022 09:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646301019; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ubKAZNJfzQMwB9O0uiiEXpS+3NjvOwpD02nWJXqgjzQ=;
        b=gxGPxfb9v3FpyGN78juHcEDhTg6tTJfXaLdNFwpcs4yGmZh7DuoViPZGU/KSWwtWMIyCsq
        QiIRKSWET4Jp0w/T6oAfG2ohMu9NrElDTJke6ZzNBkNqxKOUfZ1vbTffhaHyxR5MaEi3Ab
        GrWcLzlIJQHA/0ViErpPadB45cHCnZs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646301019;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ubKAZNJfzQMwB9O0uiiEXpS+3NjvOwpD02nWJXqgjzQ=;
        b=F+0U75I2ilyTMzMHzlFYQMORbYN1hP2ZChGcjE8xmfrGl/m9IQsG5M9j4nK0VSyjs2ob3N
        ogWgQLG4BdU5IYCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B3C9013AB4;
        Thu,  3 Mar 2022 09:50:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id O7AEKVqPIGIXcQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 03 Mar 2022 09:50:18 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 4e315d80;
        Thu, 3 Mar 2022 09:50:34 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH v3 0/6] ceph: encrypt the snapshot directories
References: <20220302121323.240432-1-xiubli@redhat.com>
        <87mti88isf.fsf@brahms.olymp>
        <4a879416-86dc-fdca-7cb3-36aff28f5ce8@redhat.com>
Date:   Thu, 03 Mar 2022 09:50:34 +0000
In-Reply-To: <4a879416-86dc-fdca-7cb3-36aff28f5ce8@redhat.com> (Xiubo Li's
        message of "Thu, 3 Mar 2022 10:49:29 +0800")
Message-ID: <87v8wv4b6d.fsf@brahms.olymp>
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

> On 3/2/22 11:40 PM, Lu=C3=ADs Henriques wrote:
>> Hi Xiubo,
>>
>> xiubli@redhat.com writes:
>>
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> This patch series is base on the 'wip-fscrypt' branch in ceph-client.
>> I gave this patchset a try but it looks broken.  For example, if 'mydir'
>> is an encrypted *and* locked directory doing:
>>
>> # ls -l mydir/.snap
>>
>> will result in:
>>
>> fscrypt (ceph, inode 1099511627782): Error -105 getting encryption conte=
xt
>
> Sorry, I forgot to mention you need the following ceph PRs:
>
> https://github.com/ceph/ceph/pull/45208
>
> https://github.com/ceph/ceph/pull/45192

Oh, wow!  I completely missed those PRs.  Yeah, that would probably
explain why it was not working for me.

Cheers,
--=20
Lu=C3=ADs

>
>
>> My RFC patch had an issue that I haven't fully analyzed (and that I
>> "fixed" using the d_drop()).  But why is the much simpler approach I used
>> not acceptable? (I.e simply use fscryt_auth from parent in
>> ceph_get_snapdir()).
>
> Sorry, I missed reading your patch. I will check more carefully about tha=
t.
>
> This patch series is mainly supporting other features, that is the long s=
nap
> names inheirt from parent snaprealms.
>
> I will drop the related patch here and cherry-pick to use yours then and =
do the
> test.
>
> - Xiubo
>
>>
>>> V3:
>>> - Add more detail comments in the commit comments and code comments.
>>> - Fix some bugs.
>>> - Improved the patches.
>>> - Remove the already merged patch.
>>>
>>> V2:
>>> - Fix several bugs, such as for the long snap name encrypt/dencrypt
>>> - Skip double dencypting dentry names for readdir
>>>
>>> =3D=3D=3D=3D=3D=3D
>>>
>>> NOTE: This patch series won't fix the long snap shot issue as Luis
>>> is working on that.
>> Yeah, I'm getting back to it right now.  Let's see if I can untangle this
>> soon ;-)
>>
>> Cheers,
>
