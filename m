Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567B31DE199
	for <lists+ceph-devel@lfdr.de>; Fri, 22 May 2020 10:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbgEVIOJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 22 May 2020 04:14:09 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42467 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728152AbgEVIOH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 22 May 2020 04:14:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590135245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZSdqG3iIOwv/t8WO+2JQ5sKlkT6OF6Wr/YHmz3ybQb4=;
        b=UlmJLr8tZBv4FrQAiLXvSgCKSvyAyf1Px/fJbT7Sz0ApTM3qAn/uqT/KU39o8LC4lytjKf
        U7Bgrfi15Srb8NLrmj8y/AkSHpBFL7EJsg6UyP3uW3p3th1ZqIAUOzKOmlzxx2eM9tbAhC
        4hHow2o7zNGpynkNgJYOb42bsSz7tC4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-TAspUXWGM7qglIYN-_5OeQ-1; Fri, 22 May 2020 04:14:00 -0400
X-MC-Unique: TAspUXWGM7qglIYN-_5OeQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE8591005512;
        Fri, 22 May 2020 08:13:58 +0000 (UTC)
Received: from [10.72.12.125] (ovpn-12-125.pek2.redhat.com [10.72.12.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 883F15C1D0;
        Fri, 22 May 2020 08:13:56 +0000 (UTC)
Subject: Re: [PATCH] ceph: add ceph_async_check_caps() to avoid double lock
 and deadlock
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Zheng Yan <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <1590046576-1262-1-git-send-email-xiubli@redhat.com>
 <CAAM7YAmoCHXB1fLSXt0fqOczqbm9s_2yfWbyAaaMuQRCNR5+3Q@mail.gmail.com>
 <c1cfcbda-217a-18ca-4320-99f67696f85d@redhat.com>
 <CAAM7YAm3h4zLN68R2akE3+MatQe2SBd_d5o5CvZGisRrMapCBg@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <91bdc43b-ff26-1bc8-c7c4-fb556b366cd5@redhat.com>
Date:   Fri, 22 May 2020 16:13:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAAM7YAm3h4zLN68R2akE3+MatQe2SBd_d5o5CvZGisRrMapCBg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/5/22 16:01, Yan, Zheng wrote:
> On Fri, May 22, 2020 at 3:31 PM Xiubo Li <xiubli@redhat.com> wrote:
>> On 2020/5/21 16:45, Yan, Zheng wrote:
>>> On Thu, May 21, 2020 at 3:39 PM <xiubli@redhat.com> wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> In the ceph_check_caps() it may call the session lock/unlock stuff.
>>>>
>>>> There have some deadlock cases, like:
>>>> handle_forward()
>>>> ...
>>>> mutex_lock(&mdsc->mutex)
>>>> ...
>>>> ceph_mdsc_put_request()
>>>>     --> ceph_mdsc_release_request()
>>>>       --> ceph_put_cap_request()
>>>>         --> ceph_put_cap_refs()
>>>>           --> ceph_check_caps()
>>>> ...
>>>> mutex_unlock(&mdsc->mutex)
>>> For this case, it's better to call ceph_mdsc_put_request() after
>>> unlock mdsc->mutex
>> Hi Zheng Yan, Jeff
>>
>> For this case there at least have 6 places, for some cases we can call
>> ceph_mdsc_put_request() after unlock mdsc->mutex very easily, but for
>> the others like:
>>
>> cleanup_session_requests()
>>
>>       --> mutex_lock(&mdsc->mutex);
>>
>>       --> __unregister_request()
>>
>>           --> ceph_mdsc_put_request() ===> will call session lock/unlock pair
>>
>>       --> mutex_unlock(&mdsc->mutex);
>>
>> There also has some more complicated cases, such as in handle_session(do
>> the mdsc->mutex lock/unlock pair) --> __wake_requests() -->
>> __do_request() --> __unregister_request() --> ceph_mdsc_put_request().
>>
>> Maybe using the ceph_async_check_caps() is a better choice here, any idea ?
>>
> I think it's better to put_cap_refs async (only for
> ceph_mdsc_release_dir_caps) instead of async check_caps.
>
>> Thanks
>>
>> BRs
>>
>> Xiubo
>>
>>
>>>> And also there maybe has some double session lock cases, like:
>>>>
>>>> send_mds_reconnect()
>>>> ...
>>>> mutex_lock(&session->s_mutex);
>>>> ...
>>>>     --> replay_unsafe_requests()
>>>>       --> ceph_mdsc_release_dir_caps()
>>>>         --> ceph_put_cap_refs()
>>>>           --> ceph_check_caps()
>>>> ...
>>>> mutex_unlock(&session->s_mutex);
>>> There is no point to check_caps() and send cap message while
>>> reconnecting caps. So I think it's better to just skip calling
>>> ceph_check_caps() for this case.

Yeah, looks better and will fix it.

Thanks
BRs
Xiubo


>>>
>>> Regards
>>> Yan, Zheng
>>>
>>>> URL: https://tracker.ceph.com/issues/45635
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/caps.c  |  2 +-
>>>>    fs/ceph/inode.c | 10 ++++++++++
>>>>    fs/ceph/super.h | 12 ++++++++++++
>>>>    3 files changed, 23 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>>> index 27c2e60..08194c4 100644
>>>> --- a/fs/ceph/caps.c
>>>> +++ b/fs/ceph/caps.c
>>>> @@ -3073,7 +3073,7 @@ void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
>>>>                last ? " last" : "", put ? " put" : "");
>>>>
>>>>           if (last)
>>>> -               ceph_check_caps(ci, 0, NULL);
>>>> +               ceph_async_check_caps(ci);
>>>>           else if (flushsnaps)
>>>>                   ceph_flush_snaps(ci, NULL);
>>>>           if (wake)
>>>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>>>> index 357c937..84a61d4 100644
>>>> --- a/fs/ceph/inode.c
>>>> +++ b/fs/ceph/inode.c
>>>> @@ -35,6 +35,7 @@
>>>>    static const struct inode_operations ceph_symlink_iops;
>>>>
>>>>    static void ceph_inode_work(struct work_struct *work);
>>>> +static void ceph_check_caps_work(struct work_struct *work);
>>>>
>>>>    /*
>>>>     * find or create an inode, given the ceph ino number
>>>> @@ -518,6 +519,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
>>>>           INIT_LIST_HEAD(&ci->i_snap_flush_item);
>>>>
>>>>           INIT_WORK(&ci->i_work, ceph_inode_work);
>>>> +       INIT_WORK(&ci->check_caps_work, ceph_check_caps_work);
>>>>           ci->i_work_mask = 0;
>>>>           memset(&ci->i_btime, '\0', sizeof(ci->i_btime));
>>>>
>>>> @@ -2012,6 +2014,14 @@ static void ceph_inode_work(struct work_struct *work)
>>>>           iput(inode);
>>>>    }
>>>>
>>>> +static void ceph_check_caps_work(struct work_struct *work)
>>>> +{
>>>> +       struct ceph_inode_info *ci = container_of(work, struct ceph_inode_info,
>>>> +                                                 check_caps_work);
>>>> +
>>>> +       ceph_check_caps(ci, 0, NULL);
>>>> +}
>>>> +
>>>>    /*
>>>>     * symlinks
>>>>     */
>>>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>>>> index 226f19c..96d0e41 100644
>>>> --- a/fs/ceph/super.h
>>>> +++ b/fs/ceph/super.h
>>>> @@ -421,6 +421,8 @@ struct ceph_inode_info {
>>>>           struct timespec64 i_btime;
>>>>           struct timespec64 i_snap_btime;
>>>>
>>>> +       struct work_struct check_caps_work;
>>>> +
>>>>           struct work_struct i_work;
>>>>           unsigned long  i_work_mask;
>>>>
>>>> @@ -1102,6 +1104,16 @@ extern void ceph_flush_snaps(struct ceph_inode_info *ci,
>>>>    extern bool __ceph_should_report_size(struct ceph_inode_info *ci);
>>>>    extern void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>>>>                               struct ceph_mds_session *session);
>>>> +static void inline
>>>> +ceph_async_check_caps(struct ceph_inode_info *ci)
>>>> +{
>>>> +       struct inode *inode = &ci->vfs_inode;
>>>> +
>>>> +       /* It's okay if queue_work fails */
>>>> +       queue_work(ceph_inode_to_client(inode)->inode_wq,
>>>> +                  &ceph_inode(inode)->check_caps_work);
>>>> +}
>>>> +
>>>>    extern void ceph_check_delayed_caps(struct ceph_mds_client *mdsc);
>>>>    extern void ceph_flush_dirty_caps(struct ceph_mds_client *mdsc);
>>>>    extern int  ceph_drop_caps_for_unlink(struct inode *inode);
>>>> --
>>>> 1.8.3.1
>>>>

