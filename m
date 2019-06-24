Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA9E24FEA5
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Jun 2019 03:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbfFXBtc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 23 Jun 2019 21:49:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51850 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726323AbfFXBtb (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 23 Jun 2019 21:49:31 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2C2808552E
        for <ceph-devel@vger.kernel.org>; Mon, 24 Jun 2019 01:49:31 +0000 (UTC)
Received: from [10.72.12.91] (ovpn-12-91.pek2.redhat.com [10.72.12.91])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 802FC5D739;
        Mon, 24 Jun 2019 01:49:28 +0000 (UTC)
Subject: Re: [PATCH 4/8] ceph: allow remounting aborted mount
To:     Jeff Layton <jlayton@redhat.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>
References: <20190617125529.6230-1-zyan@redhat.com>
 <20190617125529.6230-5-zyan@redhat.com>
 <86f838f18f0871d6c21ae7bfb97541f1de8d918f.camel@redhat.com>
 <3b0a4024-d47e-0a3f-48ca-0f1f657e9da9@redhat.com>
 <e220f9e72b736141c39da52eb7d8d00b97a2c040.camel@redhat.com>
 <CAAM7YAmaQ6eC_zcC7xFr9c6XMOsJvR=TFXZ__i_+jnxQf5MmtA@mail.gmail.com>
 <03262ecae2386444d50571484fbe21592d4d3f95.camel@redhat.com>
 <d45fef05-5b6c-5919-fa0f-98e900c7f05b@redhat.com>
 <2cc051f6e86201ddd524b2bf6f3b04ddb89c9d36.camel@redhat.com>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <15e9508d-903b-ae32-7c6d-11b23d20e19d@redhat.com>
Date:   Mon, 24 Jun 2019 09:49:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <2cc051f6e86201ddd524b2bf6f3b04ddb89c9d36.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 24 Jun 2019 01:49:31 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 6/22/19 12:48 AM, Jeff Layton wrote:
> On Fri, 2019-06-21 at 16:10 +0800, Yan, Zheng wrote:
>> On 6/20/19 11:33 PM, Jeff Layton wrote:
>>> On Wed, 2019-06-19 at 08:24 +0800, Yan, Zheng wrote:
>>>> On Tue, Jun 18, 2019 at 6:39 PM Jeff Layton <jlayton@redhat.com> wrote:
>>>>> On Tue, 2019-06-18 at 14:25 +0800, Yan, Zheng wrote:
>>>>>> On 6/18/19 1:30 AM, Jeff Layton wrote:
>>>>>>> On Mon, 2019-06-17 at 20:55 +0800, Yan, Zheng wrote:
>>>>>>>> When remounting aborted mount, also reset client's entity addr.
>>>>>>>> 'umount -f /ceph; mount -o remount /ceph' can be used for recovering
>>>>>>>> from blacklist.
>>>>>>>>
>>>>>>>
>>>>>>> Why do I need to umount here? Once the filesystem is unmounted, then the
>>>>>>> '-o remount' becomes superfluous, no? In fact, I get an error back when
>>>>>>> I try to remount an unmounted filesystem:
>>>>>>>
>>>>>>>        $ sudo umount -f /mnt/cephfs ; sudo mount -o remount /mnt/cephfs
>>>>>>>        mount: /mnt/cephfs: mount point not mounted or bad option.
>>>>>>>
>>>>>>> My client isn't blacklisted above, so I guess you're counting on the
>>>>>>> umount returning without having actually unmounted the filesystem?
>>>>>>>
>>>>>>> I think this ought to not need a umount first. From a UI standpoint,
>>>>>>> just doing a "mount -o remount" ought to be sufficient to clear this.
>>>>>>>
>>>>>> This series is mainly for the case that mount point is not umountable.
>>>>>> If mount point is umountable, user should use 'umount -f /ceph; mount
>>>>>> /ceph'. This avoids all trouble of error handling.
>>>>>>
>>>>>
>>>>> ...
>>>>>
>>>>>> If just doing "mount -o remount", user will expect there is no
>>>>>> data/metadata get lost.  The 'mount -f' explicitly tell user this
>>>>>> operation may lose data/metadata.
>>>>>>
>>>>>>
>>>>>
>>>>> I don't think they'd expect that and even if they did, that's why we'd
>>>>> return errors on certain operations until they are cleared. But, I think
>>>>> all of this points out the main issue I have with this patchset, which
>>>>> is that it's not clear what problem this is solving.
>>>>>
>>>>> So: client gets blacklisted and we want to allow it to come back in some
>>>>> fashion. Do we expect applications that happened to be accessing that
>>>>> mount to be able to continue running, or will they need to be restarted?
>>>>> If they need to be restarted why not just expect the admin to kill them
>>>>> all off, unmount and remount and then start them back up again?
>>>>>
>>>>
>>>> The point is let users decide what to do. Some user values
>>>> availability over consistency. It's inconvenient to kill all
>>>> applications that use the mount, then do umount.
>>>>
>>>>
>>>
>>> I think I have a couple of issues with this patchset. Maybe you can
>>> convince me though:
>>>
>>> 1) The interface is really weird.
>>>
>>> You suggested that we needed to do:
>>>
>>>       # umount -f /mnt/foo ; mount -o remount /mnt/foo
>>>
>>> ...but what if I'm not really blacklisted? Didn't I just kill off all
>>> the calls in-flight with the umount -f? What if that umount actually
>>> succeeds? Then the subsequent remount call will fail.
>>>
>>> ISTM, that this interface (should we choose to accept it) should just
>>> be:
>>>
>>>       # mount -o remount /mnt/foo
>>>
>>
>> I have patch that does
>>
>> mount -o remount,force_reconnect /mnt/ceph
>>
>>
> 
> That seems clearer.
> 
>>> ...and if the client figures out that it has been blacklisted, then it
>>> does the right thing during the remount (whatever that right thing is).
>>>
>>> 2) It's not clear to me who we expect to use this.
>>>
>>> Are you targeting applications that do not use file locking? Any that do
>>> use file locking will probably need some special handling, but those
>>> that don't might be able to get by unscathed as long as they can deal
>>> with -EIO on fsync by replaying writes since the last fsync.
>>>
>>
>> Several users said they availability over consistency. For example:
>> ImageNet training, cephfs is used for storing image files.
>>
>>
> 
> Which sounds reasonable on its face...but why bother with remounting at
> that point? Why not just have the client reattempt connections until it
> succeeds (or you forcibly unmount).
> 
> For that matter, why not just redirty the pages after the writes fail in
> that case instead of forcing those users to rewrite their data? If they
> don't care about consistency that much, then that would seem to be a
> nicer way to deal with this.
> 

I'm not clear about this either

Patrack said in other email:

Because the client may not even be aware that it's acting in a rogue
fashion, e.g. by writing to some file. The only correct action for the
MDS is to kill the session and blacklist the client from talking to
the OSDs.

Now, wanting the client to recover from this by re-establishing a
session with the MDS and cluster is a reasonable next step. But the
first step must be to blacklist the client because we have no idea
what it's doing or what kind of network partitions have occurred.



> I also find all of this a little difficult to reconcile with Patrick's
> desire to forcibly terminate any application that had a file lock at the
> time of the blacklisting. That doesn't seem to be something that will
> enhance availability.
> 
> Again, I think I'm missing some piece of the bigger picture here, which
> is why I'm asking about how, specifically, we expect this to be used.
> I'd like to understand the actual use-cases here so we can ensure we're
> addressing them in the best possible fashion.
> 
>>
>>> The catch here is that not many applications do that. Most just fall
>>> over once fsync hits an error. That is a bit of a chicken and egg
>>> problem though, so that's not necessarily an argument against doing
>>> this.
>>>
>>
>>
>>
>>>>>>> Also, how would an admin know that this is something they ought to try?
>>>>>>> Is there a way for them to know that their client has been blacklisted?
>>>>>>>
>>>>>>>> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
>>>>>>>> ---
>>>>>>>>     fs/ceph/mds_client.c | 16 +++++++++++++---
>>>>>>>>     fs/ceph/super.c      | 23 +++++++++++++++++++++--
>>>>>>>>     2 files changed, 34 insertions(+), 5 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>>>>>> index 19c62cf7d5b8..188c33709d9a 100644
>>>>>>>> --- a/fs/ceph/mds_client.c
>>>>>>>> +++ b/fs/ceph/mds_client.c
>>>>>>>> @@ -1378,9 +1378,12 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>>>>>>>>                     struct ceph_cap_flush *cf;
>>>>>>>>                     struct ceph_mds_client *mdsc = fsc->mdsc;
>>>>>>>>
>>>>>>>> -         if (ci->i_wrbuffer_ref > 0 &&
>>>>>>>> -             READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN)
>>>>>>>> -                 invalidate = true;
>>>>>>>> +         if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
>>>>>>>> +                 if (inode->i_data.nrpages > 0)
>>>>>>>> +                         invalidate = true;
>>>>>>>> +                 if (ci->i_wrbuffer_ref > 0)
>>>>>>>> +                         mapping_set_error(&inode->i_data, -EIO);
>>>>>>>> +         }
>>>>>>>>
>>>>>>>>                     while (!list_empty(&ci->i_cap_flush_list)) {
>>>>>>>>                             cf = list_first_entry(&ci->i_cap_flush_list,
>>>>>>>> @@ -4350,7 +4353,12 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
>>>>>>>>                     session = __ceph_lookup_mds_session(mdsc, mds);
>>>>>>>>                     if (!session)
>>>>>>>>                             continue;
>>>>>>>> +
>>>>>>>> +         if (session->s_state == CEPH_MDS_SESSION_REJECTED)
>>>>>>>> +                 __unregister_session(mdsc, session);
>>>>>>>> +         __wake_requests(mdsc, &session->s_waiting);
>>>>>>>>                     mutex_unlock(&mdsc->mutex);
>>>>>>>> +
>>>>>>>>                     mutex_lock(&session->s_mutex);
>>>>>>>>                     __close_session(mdsc, session);
>>>>>>>>                     if (session->s_state == CEPH_MDS_SESSION_CLOSING) {
>>>>>>>> @@ -4359,9 +4367,11 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
>>>>>>>>                     }
>>>>>>>>                     mutex_unlock(&session->s_mutex);
>>>>>>>>                     ceph_put_mds_session(session);
>>>>>>>> +
>>>>>>>>                     mutex_lock(&mdsc->mutex);
>>>>>>>>                     kick_requests(mdsc, mds);
>>>>>>>>             }
>>>>>>>> +
>>>>>>>>             __wake_requests(mdsc, &mdsc->waiting_for_map);
>>>>>>>>             mutex_unlock(&mdsc->mutex);
>>>>>>>>     }
>>>>>>>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>>>>>>>> index 67eb9d592ab7..a6a3c065f697 100644
>>>>>>>> --- a/fs/ceph/super.c
>>>>>>>> +++ b/fs/ceph/super.c
>>>>>>>> @@ -833,8 +833,27 @@ static void ceph_umount_begin(struct super_block *sb)
>>>>>>>>
>>>>>>>>     static int ceph_remount(struct super_block *sb, int *flags, char *data)
>>>>>>>>     {
>>>>>>>> - sync_filesystem(sb);
>>>>>>>> - return 0;
>>>>>>>> + struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
>>>>>>>> +
>>>>>>>> + if (fsc->mount_state != CEPH_MOUNT_SHUTDOWN) {
>>>>>>>> +         sync_filesystem(sb);
>>>>>>>> +         return 0;
>>>>>>>> + }
>>>>>>>> +
>>>>>>>> + /* Make sure all page caches get invalidated.
>>>>>>>> +  * see remove_session_caps_cb() */
>>>>>>>> + flush_workqueue(fsc->inode_wq);
>>>>>>>> + /* In case that we were blacklisted. This also reset
>>>>>>>> +  * all mon/osd connections */
>>>>>>>> + ceph_reset_client_addr(fsc->client);
>>>>>>>> +
>>>>>>>> + ceph_osdc_clear_abort_err(&fsc->client->osdc);
>>>>>>>> + fsc->mount_state = 0;
>>>>>>>> +
>>>>>>>> + if (!sb->s_root)
>>>>>>>> +         return 0;
>>>>>>>> + return __ceph_do_getattr(d_inode(sb->s_root), NULL,
>>>>>>>> +                          CEPH_STAT_CAP_INODE, true);
>>>>>>>>     }
>>>>>>>>
>>>>>>>>     static const struct super_operations ceph_super_ops = {
>>>>>
>>>>> --
>>>>> Jeff Layton <jlayton@redhat.com>
>>>>>
> 

