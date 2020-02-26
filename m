Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F04F21700D3
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Feb 2020 15:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbgBZOLM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Feb 2020 09:11:12 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32623 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727127AbgBZOLL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Feb 2020 09:11:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582726270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B+piLIXlZSL4Dc9WJY4FgpVHZYJhxjuUUycRFTN0rbI=;
        b=IMmcpoVLykjWp1BeydE+0JtoFsKLeupC+pD1VX9ah2e57iNdUYgO1JE1iYlKZSUf9yTCjq
        pc/pIfXhIu93moxRtqwY4BeYVPoRxTWDBNCBPGJAwIYokxc23EdxALbyqyeMSLbPjrbWWS
        krH5R0tIcR61irbJ6HcZGP9PdLO+K0U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-f5GlB48BNhy4w4Dy4PlxWg-1; Wed, 26 Feb 2020 09:11:06 -0500
X-MC-Unique: f5GlB48BNhy4w4Dy4PlxWg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F6AA107ACC4;
        Wed, 26 Feb 2020 14:11:05 +0000 (UTC)
Received: from [10.72.12.122] (ovpn-12-122.pek2.redhat.com [10.72.12.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA4459298B;
        Wed, 26 Feb 2020 14:10:55 +0000 (UTC)
Subject: Re: [PATCH v5 03/12] ceph: add infrastructure for waiting for async
 create to complete
To:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Xiubo Li <xiubli@redhat.com>
References: <20200219132526.17590-1-jlayton@kernel.org>
 <20200219132526.17590-4-jlayton@kernel.org>
 <CAAM7YAn-bXrOHGrF4O0WY4hB7ZUj7_uCT=qy3NphbNbw15F6hA@mail.gmail.com>
 <89ba8857af29c0e877d22e2188f86142f316454a.camel@kernel.org>
 <CAAM7YAk0B5ANUT+B8sK1ddgFxBcinVXjiF9KpAdfU5chKWDX1g@mail.gmail.com>
 <24351fa5e28fd92b761e29ca8dfca6253c501cf3.camel@kernel.org>
 <53d1e5e12350c84daf3584c98517ec009429920c.camel@kernel.org>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <8081f019-1623-b6f0-bc1d-13b40df0eefd@redhat.com>
Date:   Wed, 26 Feb 2020 22:10:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <53d1e5e12350c84daf3584c98517ec009429920c.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2/26/20 3:45 AM, Jeff Layton wrote:
> On Thu, 2020-02-20 at 09:53 -0500, Jeff Layton wrote:
>> On Thu, 2020-02-20 at 21:33 +0800, Yan, Zheng wrote:
>>> On Thu, Feb 20, 2020 at 9:01 PM Jeff Layton <jlayton@kernel.org> wrote:
>>>> On Thu, 2020-02-20 at 11:32 +0800, Yan, Zheng wrote:
>>>>> On Wed, Feb 19, 2020 at 9:27 PM Jeff Layton <jlayton@kernel.org> wrote:
>>>>>> When we issue an async create, we must ensure that any later on-the-wire
>>>>>> requests involving it wait for the create reply.
>>>>>>
>>>>>> Expand i_ceph_flags to be an unsigned long, and add a new bit that
>>>>>> MDS requests can wait on. If the bit is set in the inode when sending
>>>>>> caps, then don't send it and just return that it has been delayed.
>>>>>>
>>>>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>>>>> ---
>>>>>>   fs/ceph/caps.c       | 13 ++++++++++++-
>>>>>>   fs/ceph/dir.c        |  2 +-
>>>>>>   fs/ceph/mds_client.c | 20 +++++++++++++++++++-
>>>>>>   fs/ceph/mds_client.h |  7 +++++++
>>>>>>   fs/ceph/super.h      |  4 +++-
>>>>>>   5 files changed, 42 insertions(+), 4 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>>>>> index d05717397c2a..85e13aa359d2 100644
>>>>>> --- a/fs/ceph/caps.c
>>>>>> +++ b/fs/ceph/caps.c
>>>>>> @@ -511,7 +511,7 @@ static void __cap_delay_requeue(struct ceph_mds_client *mdsc,
>>>>>>                                  struct ceph_inode_info *ci,
>>>>>>                                  bool set_timeout)
>>>>>>   {
>>>>>> -       dout("__cap_delay_requeue %p flags %d at %lu\n", &ci->vfs_inode,
>>>>>> +       dout("__cap_delay_requeue %p flags 0x%lx at %lu\n", &ci->vfs_inode,
>>>>>>               ci->i_ceph_flags, ci->i_hold_caps_max);
>>>>>>          if (!mdsc->stopping) {
>>>>>>                  spin_lock(&mdsc->cap_delay_lock);
>>>>>> @@ -1294,6 +1294,13 @@ static int __send_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
>>>>>>          int delayed = 0;
>>>>>>          int ret;
>>>>>>
>>>>>> +       /* Don't send anything if it's still being created. Return delayed */
>>>>>> +       if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
>>>>>> +               spin_unlock(&ci->i_ceph_lock);
>>>>>> +               dout("%s async create in flight for %p\n", __func__, inode);
>>>>>> +               return 1;
>>>>>> +       }
>>>>>> +
>>>>>
>>>>> Maybe it's better to check this in ceph_check_caps().  Other callers
>>>>> of __send_cap() shouldn't encounter async creating inode
> 
> I'm not sure that's the case, is it? Suppose we call ceph_check_caps
> and it ends up delayed. We requeue the cap and then later someone calls
> fsync() and we end up calling try_flush_caps even though we haven't
> gotten the async create reply yet.

your patch adds a wait_on_async_create for fsync case.

> 
>>>>
>>>> I've been looking, but what actually guarantees that?
>>>>
>>>> Only ceph_check_caps calls it for UPDATE, but the other two callers call
>>>> it for FLUSH. I don't see what prevents the kernel from (e.g.) calling
>>>> write_inode before the create reply comes in, particularly if we just
>>>> create and then close the file.
>>>>
>>>
>>> I missed write_inode case. but make __send_cap() skip sending message
>>> can cause problem. For example, if we skip a message that flush dirty
>>> caps. call ceph_check_caps() again may not re-do the flush.
>>>
>>
>> Ugh. Ok, so I guess we'll need to fix that first. I assume that making
>> sure the flush is redone after being delayed is the right thing to do
>> here?
>>
> 
> Hmm...looking at this more closely today.
> 
> __send_cap calls send_cap_msg, and that function does a number of
> allocations which could fail. So if this is a problem, it's a problem
> today, and we should fix it. There are 3 callers of __send_cap:
> 
> try_flush_caps : requeues the cap (and sets the timeouts) if __send_cap
> returns non-zero. I think this one is (probably?) OK.
> 
I think we can return error back to fsync() for this case.

> __kick_flushing_caps : just throws a pr_err if __send_cap returns non-
> zero, but since the cap is already queued here, there should be no need
> to requeue it.
>

This one is really problematic. ceph_early_kick_flushing_caps() needs to 
re-send flushes when recovering mds is in reconnect state. Otherwise, 
flush may overwrite other client's new change.


> ceph_check_caps : the cap is requeued iff it's delayed.
> 
> So...I'm not sure I fully understand your concern. AFAICT, the cap
> should end up being queued if the send failed.

If ceph_check_caps flushed dirty cap and it failed to send msg. it need 
to undo what __mark_caps_flushing() did

> 
> I think that's probably the best we can do here. If we end up trying to
> flush caps and we haven't gotten the async reply yet, we don't really
> have much of a choice other than to wait to flush.
> 

I think the best is make send_cap_msg never fail. If free memory is 
slow, make the memory allocation wait.

> Perhaps though, we ought to call __kick_flushing_caps when an async
> create reply comes in just to ensure that we do flush in a timely
> fashion once that does occur.
> 
> Thoughts?
> 
> 
>>>> As a side note, I still struggle with the fact thatthere seems to be no
>>>> coherent overall description of the cap protocol. What distinguishes a
>>>> FLUSH from an UPDATE, for instance? The MDS code and comments seem to
>>>> treat them somewhat interchangeably.
>>>>
>>>
>>> UPDATE is super set of FLUSH, UPDATE can always replace FLUSH.
>>>
>>
>> I'll toss this note onto my jumble of notes, for my (eventual) planned
>> document that describes the cap protocol.
>>
>>>>>>          held = cap->issued | cap->implemented;
>>>>>>          revoking = cap->implemented & ~cap->issued;
>>>>>>          retain &= ~revoking;
>>>>>> @@ -2250,6 +2257,10 @@ int ceph_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>>>>>>          if (datasync)
>>>>>>                  goto out;
>>>>>>
>>>>>> +       ret = ceph_wait_on_async_create(inode);
>>>>>> +       if (ret)
>>>>>> +               goto out;
>>>>>> +
>>>>>>          dirty = try_flush_caps(inode, &flush_tid);
>>>>>>          dout("fsync dirty caps are %s\n", ceph_cap_string(dirty));
>>>>>>
>>>>>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>>>>>> index a87274935a09..5b83bda57056 100644
>>>>>> --- a/fs/ceph/dir.c
>>>>>> +++ b/fs/ceph/dir.c
>>>>>> @@ -752,7 +752,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
>>>>>>                  struct ceph_dentry_info *di = ceph_dentry(dentry);
>>>>>>
>>>>>>                  spin_lock(&ci->i_ceph_lock);
>>>>>> -               dout(" dir %p flags are %d\n", dir, ci->i_ceph_flags);
>>>>>> +               dout(" dir %p flags are 0x%lx\n", dir, ci->i_ceph_flags);
>>>>>>                  if (strncmp(dentry->d_name.name,
>>>>>>                              fsc->mount_options->snapdir_name,
>>>>>>                              dentry->d_name.len) &&
>>>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>>>> index 94d18e643a3d..38eb9dd5062b 100644
>>>>>> --- a/fs/ceph/mds_client.c
>>>>>> +++ b/fs/ceph/mds_client.c
>>>>>> @@ -2730,7 +2730,7 @@ static void kick_requests(struct ceph_mds_client *mdsc, int mds)
>>>>>>   int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
>>>>>>                                struct ceph_mds_request *req)
>>>>>>   {
>>>>>> -       int err;
>>>>>> +       int err = 0;
>>>>>>
>>>>>>          /* take CAP_PIN refs for r_inode, r_parent, r_old_dentry */
>>>>>>          if (req->r_inode)
>>>>>> @@ -2743,6 +2743,24 @@ int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
>>>>>>                  ceph_get_cap_refs(ceph_inode(req->r_old_dentry_dir),
>>>>>>                                    CEPH_CAP_PIN);
>>>>>>
>>>>>> +       if (req->r_inode) {
>>>>>> +               err = ceph_wait_on_async_create(req->r_inode);
>>>>>> +               if (err) {
>>>>>> +                       dout("%s: wait for async create returned: %d\n",
>>>>>> +                            __func__, err);
>>>>>> +                       return err;
>>>>>> +               }
>>>>>> +       }
>>>>>> +
>>>>>> +       if (!err && req->r_old_inode) {
>>>>>> +               err = ceph_wait_on_async_create(req->r_old_inode);
>>>>>> +               if (err) {
>>>>>> +                       dout("%s: wait for async create returned: %d\n",
>>>>>> +                            __func__, err);
>>>>>> +                       return err;
>>>>>> +               }
>>>>>> +       }
>>>>>> +
>>>>>>          dout("submit_request on %p for inode %p\n", req, dir);
>>>>>>          mutex_lock(&mdsc->mutex);
>>>>>>          __register_request(mdsc, req, dir);
>>>>>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>>>>>> index 95ac00e59e66..8043f2b439b1 100644
>>>>>> --- a/fs/ceph/mds_client.h
>>>>>> +++ b/fs/ceph/mds_client.h
>>>>>> @@ -538,4 +538,11 @@ extern void ceph_mdsc_open_export_target_sessions(struct ceph_mds_client *mdsc,
>>>>>>   extern int ceph_trim_caps(struct ceph_mds_client *mdsc,
>>>>>>                            struct ceph_mds_session *session,
>>>>>>                            int max_caps);
>>>>>> +static inline int ceph_wait_on_async_create(struct inode *inode)
>>>>>> +{
>>>>>> +       struct ceph_inode_info *ci = ceph_inode(inode);
>>>>>> +
>>>>>> +       return wait_on_bit(&ci->i_ceph_flags, CEPH_ASYNC_CREATE_BIT,
>>>>>> +                          TASK_INTERRUPTIBLE);
>>>>>> +}
>>>>>>   #endif
>>>>>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>>>>>> index 3430d7ffe8f7..bfb03adb4a08 100644
>>>>>> --- a/fs/ceph/super.h
>>>>>> +++ b/fs/ceph/super.h
>>>>>> @@ -316,7 +316,7 @@ struct ceph_inode_info {
>>>>>>          u64 i_inline_version;
>>>>>>          u32 i_time_warp_seq;
>>>>>>
>>>>>> -       unsigned i_ceph_flags;
>>>>>> +       unsigned long i_ceph_flags;
>>>>>>          atomic64_t i_release_count;
>>>>>>          atomic64_t i_ordered_count;
>>>>>>          atomic64_t i_complete_seq[2];
>>>>>> @@ -524,6 +524,8 @@ static inline struct inode *ceph_find_inode(struct super_block *sb,
>>>>>>   #define CEPH_I_ERROR_WRITE     (1 << 10) /* have seen write errors */
>>>>>>   #define CEPH_I_ERROR_FILELOCK  (1 << 11) /* have seen file lock errors */
>>>>>>   #define CEPH_I_ODIRECT         (1 << 12) /* inode in direct I/O mode */
>>>>>> +#define CEPH_ASYNC_CREATE_BIT  (13)      /* async create in flight for this */
>>>>>> +#define CEPH_I_ASYNC_CREATE    (1 << CEPH_ASYNC_CREATE_BIT)
>>>>>>
>>>>>>   /*
>>>>>>    * Masks of ceph inode work.
>>>>>> --
>>>>>> 2.24.1
>>>>>>
>>>>
>>>> --
>>>> Jeff Layton <jlayton@kernel.org>
>>>>
> 

