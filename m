Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A1C679526
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Jan 2023 11:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbjAXK1r (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 24 Jan 2023 05:27:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233279AbjAXK1q (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 24 Jan 2023 05:27:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0EEF6E8E
        for <ceph-devel@vger.kernel.org>; Tue, 24 Jan 2023 02:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674556015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PwGyaFUqd+8qyJhQXRjCEV9G/m8yH0k/mpmKA2H8Uwk=;
        b=haSAgLtAYldFAeTDCx4pvlyME9J5cc/ijZlc4gU2qrvjG1g8G2VwNgKoNNr+v3Qe0e4lzZ
        FpAAWf46tEA0gpW93NnFV1zXqyXk4mscr3sYr/t914pEB263dTm0u2vsdltkFA8GjYCjMM
        pawqhNHhsWWl/pKUNA/KWk9UmjFCbZ0=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-78--OR5gNDmMliaIlXUf7LPIQ-1; Tue, 24 Jan 2023 05:26:54 -0500
X-MC-Unique: -OR5gNDmMliaIlXUf7LPIQ-1
Received: by mail-pl1-f198.google.com with SMTP id j16-20020a170902da9000b00194c056109eso8778009plx.18
        for <ceph-devel@vger.kernel.org>; Tue, 24 Jan 2023 02:26:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PwGyaFUqd+8qyJhQXRjCEV9G/m8yH0k/mpmKA2H8Uwk=;
        b=N7FzkpUyrdR/GDuyJ/jU///9Azz4vVnbT/iiUNFsRwPMvqm1z2yZ/kzmYdjGyImwxY
         Ls7gaW23ou+7sbc2KBisvK0h+/G/+PK5RDSjL8U74V/HJt8dcQTfyUV8mdC6zmKq8USg
         WlqHJSJsZdypOT7yCcVcoax00BxFyt/IQhnrGPpkDcr/g4BfhdgipAqLVM6d1QECKxoO
         jr8uhMhpj0yibmgMC0tuaxNrTJMPYc9uCwL7nIwaXm/dZ1cVwC8wzled+uzaDzLHDPB8
         5gWfb3Ttt2zvof4EB4IL4EdjNz/AwYCPRV/LwcmpqlP4604MSndHbYZdD6/GMq47D0r0
         VrlA==
X-Gm-Message-State: AFqh2krkGV3ExOBqj+jJhAdSkz+86M0YDZcSnZQjQ02fY5nuAsofdpEa
        x6uc83f7FVn404vaUPPVGFSabSH9l6PU2FeF96YZBKwhFPZrS40yNJIq76TIBgHAY7cTUrv3Gr5
        2b2HoC5c/7b6dgsN1Ya2x8A==
X-Received: by 2002:a17:902:e751:b0:195:32b3:2604 with SMTP id p17-20020a170902e75100b0019532b32604mr21954935plf.5.1674556013271;
        Tue, 24 Jan 2023 02:26:53 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvI7sEky904YLAUlICDDhTA7ti7Z0Xr5ItfbRS8Cg7ci3XFRSY9JK/ENUFULVPLE1DD1Y9KcQ==
X-Received: by 2002:a17:902:e751:b0:195:32b3:2604 with SMTP id p17-20020a170902e75100b0019532b32604mr21954918plf.5.1674556012907;
        Tue, 24 Jan 2023 02:26:52 -0800 (PST)
Received: from [10.72.13.156] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i3-20020a1709026ac300b0019462aa090bsm1283953plt.284.2023.01.24.02.26.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 02:26:52 -0800 (PST)
Message-ID: <e11c7958-62c6-d960-77db-e4fae33543e0@redhat.com>
Date:   Tue, 24 Jan 2023 18:26:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2] ceph: drop the messages from MDS when unmouting
Content-Language: en-US
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, vshankar@redhat.com
References: <20221221093031.132792-1-xiubli@redhat.com>
 <Y8lvXRmHKGdORhs5@suse.de> <Y8pus+5ZciJa/apW@suse.de>
 <cfd149ba-69cb-6514-db03-5cbd113bf5dc@redhat.com> <Y85eRQlbwt4Z4xko@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <Y85eRQlbwt4Z4xko@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 23/01/2023 18:15, Luís Henriques wrote:
> On Sun, Jan 22, 2023 at 09:57:46PM +0800, Xiubo Li wrote:
>> Hi Luis,
>>
>> On 20/01/2023 18:36, Luís Henriques wrote:
>>> On Thu, Jan 19, 2023 at 04:27:09PM +0000, Luís Henriques wrote:
>>>> On Wed, Dec 21, 2022 at 05:30:31PM +0800, xiubli@redhat.com wrote:
>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>
>>>>> When unmounting it will just wait for the inflight requests to be
>>>>> finished, but just before the sessions are closed the kclient still
>>>>> could receive the caps/snaps/lease/quota msgs from MDS. All these
>>>>> msgs need to hold some inodes, which will cause ceph_kill_sb() failing
>>>>> to evict the inodes in time.
>>>>>
>>>>> If encrypt is enabled the kernel generate a warning when removing
>>>>> the encrypt keys when the skipped inodes still hold the keyring:
>>>> Finally (sorry for the delay!) I managed to look into the 6.1 rebase.  It
>>>> does look good, but I started hitting the WARNING added by patch:
>>>>
>>>>     [DO NOT MERGE] ceph: make sure all the files successfully put before unmounting
>>>>
>>>> This patch seems to be working but I'm not sure we really need the extra
>>> OK, looks like I jumped the gun here: I still see the warning with your
>>> patch.
>>>
>>> I've done a quick hack and the patch below sees fix it.  But again, it
>>> will impact performance.  I'll see if I can figure out something else.
>>>
>>> Cheers,
>>> --
>>> Luís
>>>
>>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>>> index 2cd134ad02a9..bdb4efa0f9f7 100644
>>> --- a/fs/ceph/file.c
>>> +++ b/fs/ceph/file.c
>>> @@ -2988,6 +2988,21 @@ static ssize_t ceph_copy_file_range(struct file *src_file, loff_t src_off,
>>>    	return ret;
>>>    }
>>> +static int ceph_flush(struct file *file, fl_owner_t id)
>>> +{
>>> +	struct inode *inode = file_inode(file);
>>> +	int ret;
>>> +
>>> +	if ((file->f_mode & FMODE_WRITE) == 0)
>>> +		return 0;
>>> +
>>> +	ret = filemap_write_and_wait(inode->i_mapping);
>>> +	if (ret)
>>> +		ret = filemap_check_wb_err(file->f_mapping, 0);
>>> +
>>> +	return ret;
>>> +}
>>> +
>>>    const struct file_operations ceph_file_fops = {
>>>    	.open = ceph_open,
>>>    	.release = ceph_release,
>>> @@ -3005,4 +3020,5 @@ const struct file_operations ceph_file_fops = {
>>>    	.compat_ioctl = compat_ptr_ioctl,
>>>    	.fallocate	= ceph_fallocate,
>>>    	.copy_file_range = ceph_copy_file_range,
>>> +	.flush = ceph_flush,
>>>    };
>>>
>> This will only fix the second crash case in
>> https://tracker.ceph.com/issues/58126#note-6, but not the case in
>> https://tracker.ceph.com/issues/58126#note-5.
>>
>> This issue could be triggered with "test_dummy_encryption" and with
>> xfstests-dev's generic/124. You can have a try.
> OK, thanks.  I'll give it a try.  BTW, my local reproducer was
> generic/132, not generic/124.  I'll let you know if I find something.

Hi Luis,

I added some logs and found that when doing the aio_write, it will split 
to many aio requests and when the last req finished it will call the 
"writepages_finish()", which will iput() the inode and release the last 
refcount of the inode.

But it seems the complete_all() is called without the req->r_callback() 
is totally finished:

<4>[500400.268200] writepages_finish 0000000060940222 rc 0
<4>[500400.268476] writepages_finish 0000000060940222 rc 0 <===== the 
last osd req->r_callback()
<4>[500400.268515] sync_fs (blocking)  <===== unmounting begin
<4>[500400.268526] sync_fs (blocking) done
<4>[500400.268530] kill_sb after sync_filesystem 00000000a01a1cf4   <=== 
the sync_filesystem() will be called, I just added it in ceph code but 
the VFS will call it again in "kill_anon_super()"
<4>[500400.268539] ceph_evict_inode:682, dec inode 0000000044f12aa7
<4>[500400.268626] sync_fs (blocking)
<4>[500400.268631] sync_fs (blocking) done
<4>[500400.268634] evict_inodes inode 0000000060940222, i_count = 1, was 
skipped!    <=== skipped
<4>[500400.268642] fscrypt_destroy_keyring: mk 00000000baf04977 
mk_active_refs = 2
<4>[500400.268651] ceph_evict_inode:682, dec inode 0000000060940222   
<==== evict the inode in the req->r_callback()

Locally my VM is not working and I couldn't run the test for now. Could 
you help test the following patch ?

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 78b622178a3d..5cdaba0d3003 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -2539,6 +2539,7 @@ static void __complete_request(struct 
ceph_osd_request *req)

         if (req->r_callback)
                 req->r_callback(req);
+       barrier();
         complete_all(&req->r_completion);
         ceph_osdc_put_request(req);
  }

Thanks

- Xiubo


>   
>> Locally I am still reading the code to check why "sync_filesystem(s);"
>> couldn't do the same with "ceph_flush" as above.
>>
>> I am still on holiday these days and I will test this after my back.
> Sure, no problem.  Enjoy your break!
>
> Cheers,
> --
> Luís
>
>> Thanks
>>
>>
>>>> 'stopping' state.  Looking at the code, we've flushed all the workqueues
>>>> and done all the waits, so I *think* the sync_filesystem() call should be
>>>> enough.
>>>>
>>>> The other alternative I see would be to add a ->flush() to ceph_file_fops,
>>>> where we'd do a filemap_write_and_wait().  But that would probably have a
>>>> negative performance impact -- my understand is that it basically means
>>>> we'll have sync file closes.
>>>>
>>>> Cheers,
>>>> --
>>>> Luís
>>>>
>>>>> WARNING: CPU: 4 PID: 168846 at fs/crypto/keyring.c:242 fscrypt_destroy_keyring+0x7e/0xd0
>>>>> CPU: 4 PID: 168846 Comm: umount Tainted: G S  6.1.0-rc5-ceph-g72ead199864c #1
>>>>> Hardware name: Supermicro SYS-5018R-WR/X10SRW-F, BIOS 2.0 12/17/2015
>>>>> RIP: 0010:fscrypt_destroy_keyring+0x7e/0xd0
>>>>> RSP: 0018:ffffc9000b277e28 EFLAGS: 00010202
>>>>> RAX: 0000000000000002 RBX: ffff88810d52ac00 RCX: ffff88810b56aa00
>>>>> RDX: 0000000080000000 RSI: ffffffff822f3a09 RDI: ffff888108f59000
>>>>> RBP: ffff8881d394fb88 R08: 0000000000000028 R09: 0000000000000000
>>>>> R10: 0000000000000001 R11: 11ff4fe6834fcd91 R12: ffff8881d394fc40
>>>>> R13: ffff888108f59000 R14: ffff8881d394f800 R15: 0000000000000000
>>>>> FS:  00007fd83f6f1080(0000) GS:ffff88885fd00000(0000) knlGS:0000000000000000
>>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>> CR2: 00007f918d417000 CR3: 000000017f89a005 CR4: 00000000003706e0
>>>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>>> Call Trace:
>>>>> <TASK>
>>>>> generic_shutdown_super+0x47/0x120
>>>>> kill_anon_super+0x14/0x30
>>>>> ceph_kill_sb+0x36/0x90 [ceph]
>>>>> deactivate_locked_super+0x29/0x60
>>>>> cleanup_mnt+0xb8/0x140
>>>>> task_work_run+0x67/0xb0
>>>>> exit_to_user_mode_prepare+0x23d/0x240
>>>>> syscall_exit_to_user_mode+0x25/0x60
>>>>> do_syscall_64+0x40/0x80
>>>>> entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>>>> RIP: 0033:0x7fd83dc39e9b
>>>>>
>>>>> URL: https://tracker.ceph.com/issues/58126
>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>>> ---
>>>>>
>>>>> V2:
>>>>> - Fix it in ceph layer.
>>>>>
>>>>>
>>>>>    fs/ceph/caps.c       |  3 +++
>>>>>    fs/ceph/mds_client.c |  5 ++++-
>>>>>    fs/ceph/mds_client.h |  7 ++++++-
>>>>>    fs/ceph/quota.c      |  3 +++
>>>>>    fs/ceph/snap.c       |  3 +++
>>>>>    fs/ceph/super.c      | 14 ++++++++++++++
>>>>>    6 files changed, 33 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>>>> index 15d9e0f0d65a..e8a53aeb2a8c 100644
>>>>> --- a/fs/ceph/caps.c
>>>>> +++ b/fs/ceph/caps.c
>>>>> @@ -4222,6 +4222,9 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>>>>>    	dout("handle_caps from mds%d\n", session->s_mds);
>>>>> +	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED)
>>>>> +		return;
>>>>> +
>>>>>    	/* decode */
>>>>>    	end = msg->front.iov_base + msg->front.iov_len;
>>>>>    	if (msg->front.iov_len < sizeof(*h))
>>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>>> index d41ab68f0130..1ad85af49b45 100644
>>>>> --- a/fs/ceph/mds_client.c
>>>>> +++ b/fs/ceph/mds_client.c
>>>>> @@ -4869,6 +4869,9 @@ static void handle_lease(struct ceph_mds_client *mdsc,
>>>>>    	dout("handle_lease from mds%d\n", mds);
>>>>> +	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED)
>>>>> +		return;
>>>>> +
>>>>>    	/* decode */
>>>>>    	if (msg->front.iov_len < sizeof(*h) + sizeof(u32))
>>>>>    		goto bad;
>>>>> @@ -5262,7 +5265,7 @@ void send_flush_mdlog(struct ceph_mds_session *s)
>>>>>    void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
>>>>>    {
>>>>>    	dout("pre_umount\n");
>>>>> -	mdsc->stopping = 1;
>>>>> +	mdsc->stopping = CEPH_MDSC_STOPPING_BEGAIN;
>>>>>    	ceph_mdsc_iterate_sessions(mdsc, send_flush_mdlog, true);
>>>>>    	ceph_mdsc_iterate_sessions(mdsc, lock_unlock_session, false);
>>>>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>>>>> index 81a1f9a4ac3b..56f9d8077068 100644
>>>>> --- a/fs/ceph/mds_client.h
>>>>> +++ b/fs/ceph/mds_client.h
>>>>> @@ -398,6 +398,11 @@ struct cap_wait {
>>>>>    	int			want;
>>>>>    };
>>>>> +enum {
>>>>> +	CEPH_MDSC_STOPPING_BEGAIN = 1,
>>>>> +	CEPH_MDSC_STOPPING_FLUSHED = 2,
>>>>> +};
>>>>> +
>>>>>    /*
>>>>>     * mds client state
>>>>>     */
>>>>> @@ -414,7 +419,7 @@ struct ceph_mds_client {
>>>>>    	struct ceph_mds_session **sessions;    /* NULL for mds if no session */
>>>>>    	atomic_t		num_sessions;
>>>>>    	int                     max_sessions;  /* len of sessions array */
>>>>> -	int                     stopping;      /* true if shutting down */
>>>>> +	int                     stopping;      /* the stage of shutting down */
>>>>>    	atomic64_t		quotarealms_count; /* # realms with quota */
>>>>>    	/*
>>>>> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
>>>>> index 64592adfe48f..f5819fc31d28 100644
>>>>> --- a/fs/ceph/quota.c
>>>>> +++ b/fs/ceph/quota.c
>>>>> @@ -47,6 +47,9 @@ void ceph_handle_quota(struct ceph_mds_client *mdsc,
>>>>>    	struct inode *inode;
>>>>>    	struct ceph_inode_info *ci;
>>>>> +	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED)
>>>>> +		return;
>>>>> +
>>>>>    	if (msg->front.iov_len < sizeof(*h)) {
>>>>>    		pr_err("%s corrupt message mds%d len %d\n", __func__,
>>>>>    		       session->s_mds, (int)msg->front.iov_len);
>>>>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>>>>> index a73943e51a77..eeabdd0211d8 100644
>>>>> --- a/fs/ceph/snap.c
>>>>> +++ b/fs/ceph/snap.c
>>>>> @@ -1010,6 +1010,9 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>>>>>    	int locked_rwsem = 0;
>>>>>    	bool close_sessions = false;
>>>>> +	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED)
>>>>> +		return;
>>>>> +
>>>>>    	/* decode */
>>>>>    	if (msg->front.iov_len < sizeof(*h))
>>>>>    		goto bad;
>>>>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>>>>> index f10a076f47e5..012b35be41a9 100644
>>>>> --- a/fs/ceph/super.c
>>>>> +++ b/fs/ceph/super.c
>>>>> @@ -1483,6 +1483,20 @@ static void ceph_kill_sb(struct super_block *s)
>>>>>    	ceph_mdsc_pre_umount(fsc->mdsc);
>>>>>    	flush_fs_workqueues(fsc);
>>>>> +	/*
>>>>> +	 * Though the kill_anon_super() will finally trigger the
>>>>> +	 * sync_filesystem() anyway, we still need to do it here and
>>>>> +	 * then bump the stage of shutdown. This will drop any further
>>>>> +	 * message, which makes no sense any more, from MDSs.
>>>>> +	 *
>>>>> +	 * Without this when evicting the inodes it may fail in the
>>>>> +	 * kill_anon_super(), which will trigger a warning when
>>>>> +	 * destroying the fscrypt keyring and then possibly trigger
>>>>> +	 * a further crash in ceph module when iput() the inodes.
>>>>> +	 */
>>>>> +	sync_filesystem(s);
>>>>> +	fsc->mdsc->stopping = CEPH_MDSC_STOPPING_FLUSHED;
>>>>> +
>>>>>    	kill_anon_super(s);
>>>>>    	fsc->client->extra_mon_dispatch = NULL;
>>>>> -- 
>>>>> 2.31.1
>>>>>
>> -- 
>> Best Regards,
>>
>> Xiubo Li (李秀波)
>>
>> Email: xiubli@redhat.com/xiubli@ibm.com
>> Slack: @Xiubo Li
>>
-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li

