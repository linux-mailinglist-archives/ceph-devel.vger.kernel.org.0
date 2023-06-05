Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0874B7229E0
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jun 2023 16:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233559AbjFEOyf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Jun 2023 10:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbjFEOye (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 5 Jun 2023 10:54:34 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D527A7
        for <ceph-devel@vger.kernel.org>; Mon,  5 Jun 2023 07:54:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2FC8A1FE64;
        Mon,  5 Jun 2023 14:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1685976871; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RbDmCRpmz5V5WPMPdTkCbwgeazMCfQfzM3OM2EuzBZE=;
        b=c3yc0rBJc6w5HJ+UvwclKNwBNuSNpi7I2Qxt5cldrduq0vXgAHdjuy7xJzlKvY9fl9UjNy
        fPifcLuYOKPMPiy3mgXVQOyMJDUzEdT9w9+Pvxte+SG9hZlZA5Iqa8ts7k1vMi9YgL2Pt7
        ZOW7GSXHFRXD3nutJeDkg1VQkTIE/7c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1685976871;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RbDmCRpmz5V5WPMPdTkCbwgeazMCfQfzM3OM2EuzBZE=;
        b=GYepmmhZjAIbhopPW7EUQM8DawsfHiAcS9Gy/R14BhdqoErqgUv1Gh9GwFlGMWebiC9MP0
        LM2RkNNt/o+RdmDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C6D2D139C8;
        Mon,  5 Jun 2023 14:54:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UxVpLSb3fWTdYgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 05 Jun 2023 14:54:30 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id b0aaa0bb;
        Mon, 5 Jun 2023 14:54:30 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com
Subject: Re: [PATCH] ceph: just wait the osd requests' callbacks to finish
 when unmounting
References: <20230509084637.213326-1-xiubli@redhat.com>
        <871qiu2jcx.fsf@suse.de>
        <6f9af9e3-067a-6d98-7679-915a4a6aa474@redhat.com>
Date:   Mon, 05 Jun 2023 15:54:29 +0100
In-Reply-To: <6f9af9e3-067a-6d98-7679-915a4a6aa474@redhat.com> (Xiubo Li's
        message of "Mon, 5 Jun 2023 09:57:58 +0800")
Message-ID: <874jnm9cyi.fsf@suse.de>
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

> On 6/2/23 19:29, Lu=C3=ADs Henriques wrote:
>> xiubli@redhat.com writes:
>>
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> The sync_filesystem() will flush all the dirty buffer and submit the
>>> osd reqs to the osdc and then is blocked to wait for all the reqs to
>>> finish. But the when the reqs' replies come, the reqs will be removed
>>> from osdc just before the req->r_callback()s are called. Which means
>>> the sync_filesystem() will be woke up by leaving the req->r_callback()s
>>> are still running.
>>>
>>> This will be buggy when the waiter require the req->r_callback()s to
>>> release some resources before continuing. So we need to make sure the
>>> req->r_callback()s are called before removing the reqs from the osdc.
>>>
>>> WARNING: CPU: 4 PID: 168846 at fs/crypto/keyring.c:242 fscrypt_destroy_=
keyring+0x7e/0xd0
>>> CPU: 4 PID: 168846 Comm: umount Tainted: G S  6.1.0-rc5-ceph-g72ead1998=
64c #1
>>> Hardware name: Supermicro SYS-5018R-WR/X10SRW-F, BIOS 2.0 12/17/2015
>>> RIP: 0010:fscrypt_destroy_keyring+0x7e/0xd0
>>> RSP: 0018:ffffc9000b277e28 EFLAGS: 00010202
>>> RAX: 0000000000000002 RBX: ffff88810d52ac00 RCX: ffff88810b56aa00
>>> RDX: 0000000080000000 RSI: ffffffff822f3a09 RDI: ffff888108f59000
>>> RBP: ffff8881d394fb88 R08: 0000000000000028 R09: 0000000000000000
>>> R10: 0000000000000001 R11: 11ff4fe6834fcd91 R12: ffff8881d394fc40
>>> R13: ffff888108f59000 R14: ffff8881d394f800 R15: 0000000000000000
>>> FS:  00007fd83f6f1080(0000) GS:ffff88885fd00000(0000) knlGS:00000000000=
00000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: 00007f918d417000 CR3: 000000017f89a005 CR4: 00000000003706e0
>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>> Call Trace:
>>> <TASK>
>>> generic_shutdown_super+0x47/0x120
>>> kill_anon_super+0x14/0x30
>>> ceph_kill_sb+0x36/0x90 [ceph]
>>> deactivate_locked_super+0x29/0x60
>>> cleanup_mnt+0xb8/0x140
>>> task_work_run+0x67/0xb0
>>> exit_to_user_mode_prepare+0x23d/0x240
>>> syscall_exit_to_user_mode+0x25/0x60
>>> do_syscall_64+0x40/0x80
>>> entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>> RIP: 0033:0x7fd83dc39e9b
>>>
>>> We need to increase the blocker counter to make sure all the osd
>>> requests' callbacks have been finished just before calling the
>>> kill_anon_super() when unmounting.
>> (Sorry for taking so long replying to this patch!  And I've still a few
>> others on the queue!)
>>
>> I've been looking at this patch and at patch "ceph: drop the messages fr=
om
>> MDS when unmounting", but I still can't say whether they are correct or
>> not.  They seem to be working, but they don't _look_ right.
>>
>> For example, mdsc->stopping is being used by ceph_dec_stopping_blocker()
>> and ceph_inc_stopping_blocker() for setting the ceph_mds_client state, b=
ut
>> the old usage for that field (e.g. in ceph_mdsc_pre_umount()) is being
>> kept.  Is that correct?  Maybe, but it looks wrong: the old usage isn't
>> protected by the spinlock and doesn't use the atomic counter.
>
> This is okay, the spin lock "stopping_lock" is not trying to protect the
> "stopping", and it's just trying to protect the "stopping_blockers" and t=
he
> order of accessing "fsc->mdsc->stopping" and "fsc->mdsc->stopping_blocker=
s", you
> can try without this you can reproduce it again.
>
>
>>
>> Another example: in patch "ceph: drop the messages from MDS when
>> unmounting" we're adding calls to ceph_inc_stopping_blocker() in
>> ceph_handle_caps(), ceph_handle_quota(), and ceph_handle_snap().  Are
>> those the only places where this is needed?  Obviously not, because this
>> new patch is adding extra calls in the read/write paths.  But maybe there
>> are more places...?
>
> I have gone through all the related code and this should be all the place=
s,
> which will grab the inode, we need to do this. You can confirm that.
>
>> And another one: changing ceph_inc_stopping_blocker() to accept NULL to
>> distinguish between mds and osd requests makes things look even more
>> hacky :-(
>
> This can be improved.
>
> Let me update it to make it easier to read.
>
>>
>> On the other end, I've been testing these patches thoroughly and couldn't
>> see any issues with them.  And although I'm still not convinced that they
>> will not deadlock in some corner cases, I don't have a better solution
>> either for the problem they're solving.
>>
>> FWIW you can add my:
>>
>> Tested-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
>>
>> to this patch (the other one already has it), but I'll need to spend more
>> time to see if there are better solutions.
>
> Thanks Luis for your test and review.

One final question:

Would it be better to use wait_for_completion_timeout() in ceph_kill_sb()?
I'm mostly worried with the read/write paths, of course.  For example, the
complexity of function ceph_writepages_start() makes it easy to introduce
a bug where we'll have an ceph_inc_stopping_blocker() without an
ceph_dec_stopping_blocker().

On the other hand, adding a timeout won't solve anything as we'll get the
fscrypt warning in the unlikely even of timing-out; but maybe that's more
acceptable than blocking the umount operation forever.  So, I'm not really
sure it's worth it.

Cheers,
--=20
Lu=C3=ADs
