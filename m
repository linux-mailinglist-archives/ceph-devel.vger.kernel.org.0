Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8BB2DF8E3
	for <lists+ceph-devel@lfdr.de>; Mon, 21 Dec 2020 06:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgLUFnS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 21 Dec 2020 00:43:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23438 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726644AbgLUFnR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 21 Dec 2020 00:43:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608529309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ejFL1Br6+B4G4tmd7YIvMbu1uCoPhetD2ZP9PvNybVg=;
        b=ZyUiohkM1Bl8D5mrmv/pLJVmPKCk58XRumXio05/oAH8EFyFJEzA2o9IVk6DB0Lms4QrkP
        GTnpuTm1denAAzGljly73wpkFPwtn6QZP5Bzy9ECznRN3w7KP1qB8875yFtIjXlCeQtdDN
        w7Tzj713nOFyV5877LunBfTt7lfX5gA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-dLM4GfIPO3qqAKulueHJtA-1; Mon, 21 Dec 2020 00:41:16 -0500
X-MC-Unique: dLM4GfIPO3qqAKulueHJtA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD6391005D52;
        Mon, 21 Dec 2020 05:41:15 +0000 (UTC)
Received: from [10.72.12.96] (ovpn-12-96.pek2.redhat.com [10.72.12.96])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CDE2A5D9CA;
        Mon, 21 Dec 2020 05:41:13 +0000 (UTC)
Subject: Re: [PATCH v2] ceph: implement updated ceph_mds_request_head
 structure
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>
References: <20201216195043.385741-1-jlayton@kernel.org>
 <CAOi1vP_rcAgNO2r+D9bVy4TUtmEpsTWsP7WGnEfSsMdSsjJRhA@mail.gmail.com>
 <cf73e0bde0eb4e43c0eeb0e884a468002a9f9889.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d20a27e2-0c0e-65a8-3a67-b9ba9a49de87@redhat.com>
Date:   Mon, 21 Dec 2020 13:41:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <cf73e0bde0eb4e43c0eeb0e884a468002a9f9889.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/12/17 5:04, Jeff Layton wrote:
> On Wed, 2020-12-16 at 21:16 +0100, Ilya Dryomov wrote:
>> On Wed, Dec 16, 2020 at 8:50 PM Jeff Layton <jlayton@kernel.org> wrote:
>>> When we added the btime feature in mainline ceph, we had to extend
>>> struct ceph_mds_request_args so that it could be set. Implement the same
>>> in the kernel client.
>>>
>>> Rename ceph_mds_request_head with a _old extension, and a union
>>> ceph_mds_request_args_ext to allow for the extended size of the new
>>> header format.
>>>
>>> Add the appropriate code to handle both formats in struct
>>> create_request_message and key the behavior on whether the peer supports
>>> CEPH_FEATURE_FS_BTIME.
>>>
>>> The gid_list field in the payload is now populated from the saved
>>> credential. For now, we don't add any support for setting the btime via
>>> setattr, but this does enable us to add that in the future.
>>>
>>> [ idryomov: break unnecessarily long lines ]
>>>
>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>> ---
>>>   fs/ceph/mds_client.c         | 101 ++++++++++++++++++++++++++---------
>>>   include/linux/ceph/ceph_fs.h |  32 ++++++++++-
>>>   2 files changed, 108 insertions(+), 25 deletions(-)
>>>
>>>   v2: fix encoding of unsafe request resends
>>>       add encode_payload_tail helper
>>>       rework find_old_request_head to take a "legacy" flag argument
>>>
>>> Ilya,
>>>
>>> I'll go ahead and merge this into testing, but your call on whether we
>>> should take this for v5.11, or wait for v5.12. We don't have anything
>>> blocked on this just yet.
>>>
>>> I dropped your SoB and Xiubo Reviewed-by tags as well, as the patch is
>>> a bit different from the original.
>>>
>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>> index 0ff76f21466a..cd0cc5d8c4f0 100644
>>> --- a/fs/ceph/mds_client.c
>>> +++ b/fs/ceph/mds_client.c
>>> @@ -2475,15 +2475,46 @@ static int set_request_path_attr(struct inode *rinode, struct dentry *rdentry,
>>>          return r;
>>>   }
>>>
>>> +static struct ceph_mds_request_head_old *
>>> +find_old_request_head(void *p, bool legacy)
>>> +{
>>> +       struct ceph_mds_request_head *new_head;
>>> +
>>> +       if (legacy)
>>> +               return (struct ceph_mds_request_head_old *)p;
>>> +       new_head = (struct ceph_mds_request_head *)p;
>>> +       return (struct ceph_mds_request_head_old *)&new_head->oldest_client_tid;
>>> +}
>>> +
>>> +static void encode_payload_tail(void **p, struct ceph_mds_request *req, bool legacy)
>>> +{
>>> +       struct ceph_timespec ts;
>>> +
>>> +       ceph_encode_timespec64(&ts, &req->r_stamp);
>>> +       ceph_encode_copy(p, &ts, sizeof(ts));
>>> +
>>> +       /* gid list */
>>> +       if (!legacy) {
>>> +               int i;
>>> +
>>> +               ceph_encode_32(p, req->r_cred->group_info->ngroups);
>>> +               for (i = 0; i < req->r_cred->group_info->ngroups; i++)
>>> +                       ceph_encode_64(p, from_kgid(&init_user_ns,
>>> +                                      req->r_cred->group_info->gid[i]));
>>> +       }
>>> +}
>>> +
>>>   /*
>>>    * called under mdsc->mutex
>>>    */
>>> -static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
>>> +static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
>>>                                                 struct ceph_mds_request *req,
>>> -                                              int mds, bool drop_cap_releases)
>>> +                                              bool drop_cap_releases)
>>>   {
>>> +       int mds = session->s_mds;
>>> +       struct ceph_mds_client *mdsc = session->s_mdsc;
>>>          struct ceph_msg *msg;
>>> -       struct ceph_mds_request_head *head;
>>> +       struct ceph_mds_request_head_old *head;
>>>          const char *path1 = NULL;
>>>          const char *path2 = NULL;
>>>          u64 ino1 = 0, ino2 = 0;
>>> @@ -2493,6 +2524,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
>>>          u16 releases;
>>>          void *p, *end;
>>>          int ret;
>>> +       bool legacy = !(session->s_con.peer_features & CEPH_FEATURE_FS_BTIME);
>>>
>>>          ret = set_request_path_attr(req->r_inode, req->r_dentry,
>>>                                req->r_parent, req->r_path1, req->r_ino1.ino,
>>> @@ -2514,14 +2546,23 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
>>>                  goto out_free1;
>>>          }
>>>
>>> -       len = sizeof(*head) +
>>> -               pathlen1 + pathlen2 + 2*(1 + sizeof(u32) + sizeof(u64)) +
>>> +       if (legacy) {
>>> +               /* Old style */
>>> +               len = sizeof(*head);
>>> +       } else {
>>> +               /* New style: add gid_list and any later fields */
>>> +               len = sizeof(struct ceph_mds_request_head) + sizeof(u32) +
>>> +                     (sizeof(u64) * req->r_cred->group_info->ngroups);
>>> +       }
>>> +
>>> +       len += pathlen1 + pathlen2 + 2*(1 + sizeof(u32) + sizeof(u64)) +
>>>                  sizeof(struct ceph_timespec);
>>>
>>>          /* calculate (max) length for cap releases */
>>>          len += sizeof(struct ceph_mds_request_release) *
>>>                  (!!req->r_inode_drop + !!req->r_dentry_drop +
>>>                   !!req->r_old_inode_drop + !!req->r_old_dentry_drop);
>>> +
>>>          if (req->r_dentry_drop)
>>>                  len += pathlen1;
>>>          if (req->r_old_dentry_drop)
>>> @@ -2533,11 +2574,25 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
>>>                  goto out_free2;
>>>          }
>>>
>>> -       msg->hdr.version = cpu_to_le16(3);
>>>          msg->hdr.tid = cpu_to_le64(req->r_tid);
>>>
>>> -       head = msg->front.iov_base;
>>> -       p = msg->front.iov_base + sizeof(*head);
>>> +       /*
>>> +        * The old ceph_mds_request_header didn't contain a version field, and
>>> +        * one was added when we moved the message version from 3->4.
>>> +        */
>>> +       if (legacy) {
>>> +               msg->hdr.version = cpu_to_le16(3);
>>> +               p = msg->front.iov_base + sizeof(*head);
>>> +       } else {
>>> +               struct ceph_mds_request_head *new_head = msg->front.iov_base;
>>> +
>>> +               msg->hdr.version = cpu_to_le16(4);
>>> +               new_head->version = cpu_to_le16(CEPH_MDS_REQUEST_HEAD_VERSION);
>>> +               p = msg->front.iov_base + sizeof(*new_head);
>>> +       }
>>> +
>>> +       head = find_old_request_head(msg->front.iov_base, legacy);
>>> +
>>>          end = msg->front.iov_base + msg->front.iov_len;
>>>
>>>          head->mdsmap_epoch = cpu_to_le32(mdsc->mdsmap->m_epoch);
>>> @@ -2583,12 +2638,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
>>>
>>>          head->num_releases = cpu_to_le16(releases);
>>>
>>> -       /* time stamp */
>>> -       {
>>> -               struct ceph_timespec ts;
>>> -               ceph_encode_timespec64(&ts, &req->r_stamp);
>>> -               ceph_encode_copy(&p, &ts, sizeof(ts));
>>> -       }
>>> +       encode_payload_tail(&p, req, legacy);
>>>
>>>          if (WARN_ON_ONCE(p > end)) {
>>>                  ceph_msg_put(msg);
>>> @@ -2642,9 +2692,10 @@ static int __prepare_send_request(struct ceph_mds_session *session,
>>>   {
>>>          int mds = session->s_mds;
>>>          struct ceph_mds_client *mdsc = session->s_mdsc;
>>> -       struct ceph_mds_request_head *rhead;
>>> +       struct ceph_mds_request_head_old *rhead;
>>>          struct ceph_msg *msg;
>>>          int flags = 0;
>>> +       bool legacy = !(session->s_con.peer_features & CEPH_FEATURE_FS_BTIME);
>>>
>>>          req->r_attempts++;
>>>          if (req->r_inode) {
>>> @@ -2661,6 +2712,7 @@ static int __prepare_send_request(struct ceph_mds_session *session,
>>>
>>>          if (test_bit(CEPH_MDS_R_GOT_UNSAFE, &req->r_req_flags)) {
>>>                  void *p;
>>> +
>>>                  /*
>>>                   * Replay.  Do not regenerate message (and rebuild
>>>                   * paths, etc.); just use the original message.
>>> @@ -2668,7 +2720,7 @@ static int __prepare_send_request(struct ceph_mds_session *session,
>>>                   * d_move mangles the src name.
>>>                   */
>>>                  msg = req->r_request;
>>> -               rhead = msg->front.iov_base;
>>> +               rhead = find_old_request_head(msg->front.iov_base, legacy);
>>>
>>>                  flags = le32_to_cpu(rhead->flags);
>>>                  flags |= CEPH_MDS_FLAG_REPLAY;
>>> @@ -2682,13 +2734,14 @@ static int __prepare_send_request(struct ceph_mds_session *session,
>>>                  /* remove cap/dentry releases from message */
>>>                  rhead->num_releases = 0;
>>>
>>> -               /* time stamp */
>>> +               /* verify that we haven't got mixed-feature MDSs */
>>> +               if (legacy)
>>> +                       WARN_ON_ONCE(le16_to_cpu(msg->hdr.version) >= 4);
>>> +               else
>>> +                       WARN_ON_ONCE(le16_to_cpu(msg->hdr.version) < 4);
>> As mentioned in the ticket, I already did a minimal encode_gid_list()
>> helper -- just haven't pushed because I had to leave.  Looking at this,
>> I not clear on why even bother with v3 vs v4 and the legacy branch.
>> The only that is conditional on CEPH_FEATURE_FS_BTIME is the head, we
>> can encode gids and set the version to 4 unconditionally.
>>
> We can't because legacy servers won't understand the newer struct
> ceph_mds_request_head. I'm pretty sure anything pre-luminous will barf
> on it, which is why we needed the feature bit test.
>
Yeah, agree. For the old ceph versions it may something like dropping 
the message to ground or crash the mds deamons as I hit before for the 
metric features.

