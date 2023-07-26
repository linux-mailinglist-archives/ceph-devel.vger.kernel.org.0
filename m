Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDC7B763756
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jul 2023 15:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbjGZNRe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jul 2023 09:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjGZNRc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Jul 2023 09:17:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A96B1FEC
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 06:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690377411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=codqLWTKjJLgn1GJUcavMBO/dTK2kuj8yFNG/O5Vago=;
        b=L8z45cpnmsy8KXHki03h/VHNMGseln2EK/j7C6sC5sljLgGhOox1zXMn9mjX1SS5FJmUE/
        5FI/m4nx2s3c6Sdm6YsTLe4YkdZoVWFQNwHJZz7/bAsBcPps36XGTInYuE9MHA71ztsdgl
        7AXMzsGSjaib11KCvI2m2H/pXgW0HU4=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-ZqmtQREnPzCVCXkJ-dqXLg-1; Wed, 26 Jul 2023 09:16:48 -0400
X-MC-Unique: ZqmtQREnPzCVCXkJ-dqXLg-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1bbb7ae553aso13111205ad.3
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 06:16:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690377407; x=1690982207;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=codqLWTKjJLgn1GJUcavMBO/dTK2kuj8yFNG/O5Vago=;
        b=bbnrVcj3cPpEpVRvl10fbO46dACbCcc2T/1oqZjea267rV7A70GpLo7x8iQ2n5a7WI
         N+AaVtkzYW87kr/NumReRwLEBkWlV3wNepEfmljfs9Lr02KceZkAGbVMtOq6aOTN91X6
         d0OCqut+hDPAB8Pg8rkBSXXKukbBmjUZ3ZVqzFqEH7XN4yEGCCpCXdHD/vPAC6blrSvA
         azkkLLm3eCm5KtEJ9zzLr7jwNp5U5WvwEhpFZHIXwBQIf9QRK1apcUkUOb5oavSIRUKG
         cRbwe5TLOk8kBWE+5YMBT7X5vpocnBDREjbsuEIArS+yUB6YBHd5AR+mCirFr1ndrAg6
         D7Og==
X-Gm-Message-State: ABy/qLaSz65jRdKVJbOj3rYHFq+Rk0eLdAjMoq3l7AC4DfRG728/vHE9
        JwCiCFzjBb3Vmi8eSbK2HNKYRCSOdEpO3f667Bg/rI/W3ws485yBWbjK7eeQp+aIrgbpvjJFIDZ
        r4IaeUye57lw8u8J/u9MzPQ==
X-Received: by 2002:a17:903:2308:b0:1b8:aef2:773e with SMTP id d8-20020a170903230800b001b8aef2773emr1959984plh.46.1690377406855;
        Wed, 26 Jul 2023 06:16:46 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFkYbhJ7pCQNXsYLIz6zqFXaybuL8xVVLfQfgHaBDrkYxfSnXuapxHfVXCRWT8XeA2fcje7nw==
X-Received: by 2002:a17:903:2308:b0:1b8:aef2:773e with SMTP id d8-20020a170903230800b001b8aef2773emr1959944plh.46.1690377406324;
        Wed, 26 Jul 2023 06:16:46 -0700 (PDT)
Received: from [10.72.12.127] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id s9-20020a170902b18900b001b9de39905asm13109662plr.59.2023.07.26.06.16.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jul 2023 06:16:46 -0700 (PDT)
Message-ID: <0828aa69-aeaf-e423-be6f-8c59a3c9755b@redhat.com>
Date:   Wed, 26 Jul 2023 21:16:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] ceph: make num_fwd and num_retry to __u32
Content-Language: en-US
To:     Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com
References: <20230725104438.386461-1-xiubli@redhat.com>
 <CAEivzxfsi8e3CjYhT5SHOog6TPNsWga6nWNvwQduzJHnL-Bdxw@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAEivzxfsi8e3CjYhT5SHOog6TPNsWga6nWNvwQduzJHnL-Bdxw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 7/26/23 18:06, Aleksandr Mikhalitsyn wrote:
> Hi Xiubo!
>
> On Tue, Jul 25, 2023 at 12:46 PM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The num_fwd in MClientRequestForward is int32_t, while the num_fwd
>> in ceph_mds_request_head is __u8. This is buggy when the num_fwd
>> is larger than 256 it will always be truncate to 0 again. But the
>> client couldn't recoginize this.
>>
>> This will make them to __u32 instead. Because the old cephs will
>> directly copy the raw memories when decoding the reqeust's head,
>> so we need to make sure this kclient will be compatible with old
>> cephs. For newer cephs they will decode the requests depending
>> the version, which will be much simpler and easier to extend new
>> members.
>>
>> URL: https://tracker.ceph.com/issues/62145
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c         | 191 ++++++++++++++++++-----------------
>>   fs/ceph/mds_client.h         |   4 +-
>>   include/linux/ceph/ceph_fs.h |  23 ++++-
>>   3 files changed, 124 insertions(+), 94 deletions(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 70987b3c198a..191bae3a4ee6 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -2897,6 +2897,18 @@ static void encode_mclientrequest_tail(void **p, const struct ceph_mds_request *
>>          }
>>   }
>>
>> +static struct ceph_mds_request_head_legacy *
>> +find_legacy_request_head(void *p, u64 features)
>> +{
>> +       bool legacy = !(features & CEPH_FEATURE_FS_BTIME);
>> +       struct ceph_mds_request_head_old *ohead;
>> +
>> +       if (legacy)
>> +               return (struct ceph_mds_request_head_legacy *)p;
>> +       ohead = (struct ceph_mds_request_head_old *)p;
>> +       return (struct ceph_mds_request_head_legacy *)&ohead->oldest_client_tid;
>> +}
>> +
>>   /*
>>    * called under mdsc->mutex
>>    */
>> @@ -2907,7 +2919,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
>>          int mds = session->s_mds;
>>          struct ceph_mds_client *mdsc = session->s_mdsc;
>>          struct ceph_msg *msg;
>> -       struct ceph_mds_request_head_old *head;
>> +       struct ceph_mds_request_head_legacy *lhead;
>>          const char *path1 = NULL;
>>          const char *path2 = NULL;
>>          u64 ino1 = 0, ino2 = 0;
>> @@ -2919,6 +2931,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
>>          void *p, *end;
>>          int ret;
>>          bool legacy = !(session->s_con.peer_features & CEPH_FEATURE_FS_BTIME);
>> +       bool old_version = !test_bit(CEPHFS_FEATURE_32BITS_RETRY_FWD, &session->s_features);
>>
>>          ret = set_request_path_attr(mdsc, req->r_inode, req->r_dentry,
>>                                req->r_parent, req->r_path1, req->r_ino1.ino,
>> @@ -2950,7 +2963,19 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
>>                  goto out_free2;
>>          }
>>
>> -       len = legacy ? sizeof(*head) : sizeof(struct ceph_mds_request_head);
>> +       /*
>> +        * For old cephs without supporting the 32bit retry/fwd feature
>> +        * it will copy the raw memories directly when decoding the
>> +        * requests. While new cephs will decode the head depending the
>> +        * version member, so we need to make sure it will be compatible
>> +        * with them both.
>> +        */
>> +       if (legacy)
>> +               len = sizeof(struct ceph_mds_request_head_legacy);
>> +       else if (old_version)
>> +               len = sizeof(struct ceph_mds_request_head_old);
>> +       else
>> +               len = sizeof(struct ceph_mds_request_head);
>>
>>          /* filepaths */
>>          len += 2 * (1 + sizeof(u32) + sizeof(u64));
>> @@ -2995,33 +3020,40 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
>>
>>          msg->hdr.tid = cpu_to_le64(req->r_tid);
>>
>> +       lhead = find_legacy_request_head(msg->front.iov_base,
>> +                                        session->s_con.peer_features);
>> +
>>          /*
>> -        * The old ceph_mds_request_head didn't contain a version field, and
>> +        * The ceph_mds_request_head_legacy didn't contain a version field, and
>>           * one was added when we moved the message version from 3->4.
>>           */
>>          if (legacy) {
>>                  msg->hdr.version = cpu_to_le16(3);
>> -               head = msg->front.iov_base;
>> -               p = msg->front.iov_base + sizeof(*head);
>> +               p = msg->front.iov_base + sizeof(*lhead);
>> +       } else if (old_version) {
>> +               struct ceph_mds_request_head_old *ohead = msg->front.iov_base;
>> +
>> +               msg->hdr.version = cpu_to_le16(4);
>> +               ohead->version = cpu_to_le16(CEPH_MDS_REQUEST_HEAD_VERSION);
> Don't we want to use the old mds request head version here:
> ohead->version = cpu_to_le16(1);
> ?
>
> As far as I understand the idea here is to skip new fields
> ext_num_retry/ext_num_fwd in case
> when the old_version is true. Would it be incorrect to set version to
> the latest one (CEPH_MDS_REQUEST_HEAD_VERSION)
> and at the same time skip the setting of new fields?

Hi Alex,

I noticed that, but this doesn't matter, because for the old version 
cephs they will do nothing with the version field. I am just following 
the user space code.

But to make the code to be more readable and easier to understand I will 
revise this. And also will raise one PR to fix the user space code.

Thanks

- Xiubo


> Kind regards,
> Alex
>
>> +               p = msg->front.iov_base + sizeof(*ohead);
>>          } else {
>> -               struct ceph_mds_request_head *new_head = msg->front.iov_base;
>> +               struct ceph_mds_request_head *nhead = msg->front.iov_base;
>>
>>                  msg->hdr.version = cpu_to_le16(6);
>> -               new_head->version = cpu_to_le16(CEPH_MDS_REQUEST_HEAD_VERSION);
>> -               head = (struct ceph_mds_request_head_old *)&new_head->oldest_client_tid;
>> -               p = msg->front.iov_base + sizeof(*new_head);
>> +               nhead->version = cpu_to_le16(CEPH_MDS_REQUEST_HEAD_VERSION);
>> +               p = msg->front.iov_base + sizeof(*nhead);
>>          }
>>
>>          end = msg->front.iov_base + msg->front.iov_len;
>>
>> -       head->mdsmap_epoch = cpu_to_le32(mdsc->mdsmap->m_epoch);
>> -       head->op = cpu_to_le32(req->r_op);
>> -       head->caller_uid = cpu_to_le32(from_kuid(&init_user_ns,
>> -                                                req->r_cred->fsuid));
>> -       head->caller_gid = cpu_to_le32(from_kgid(&init_user_ns,
>> -                                                req->r_cred->fsgid));
>> -       head->ino = cpu_to_le64(req->r_deleg_ino);
>> -       head->args = req->r_args;
>> +       lhead->mdsmap_epoch = cpu_to_le32(mdsc->mdsmap->m_epoch);
>> +       lhead->op = cpu_to_le32(req->r_op);
>> +       lhead->caller_uid = cpu_to_le32(from_kuid(&init_user_ns,
>> +                                                 req->r_cred->fsuid));
>> +       lhead->caller_gid = cpu_to_le32(from_kgid(&init_user_ns,
>> +                                                 req->r_cred->fsgid));
>> +       lhead->ino = cpu_to_le64(req->r_deleg_ino);
>> +       lhead->args = req->r_args;
>>
>>          ceph_encode_filepath(&p, end, ino1, path1);
>>          ceph_encode_filepath(&p, end, ino2, path2);
>> @@ -3063,7 +3095,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
>>                  p = msg->front.iov_base + req->r_request_release_offset;
>>          }
>>
>> -       head->num_releases = cpu_to_le16(releases);
>> +       lhead->num_releases = cpu_to_le16(releases);
>>
>>          encode_mclientrequest_tail(&p, req);
>>
>> @@ -3114,18 +3146,6 @@ static void complete_request(struct ceph_mds_client *mdsc,
>>          complete_all(&req->r_completion);
>>   }
>>
>> -static struct ceph_mds_request_head_old *
>> -find_old_request_head(void *p, u64 features)
>> -{
>> -       bool legacy = !(features & CEPH_FEATURE_FS_BTIME);
>> -       struct ceph_mds_request_head *new_head;
>> -
>> -       if (legacy)
>> -               return (struct ceph_mds_request_head_old *)p;
>> -       new_head = (struct ceph_mds_request_head *)p;
>> -       return (struct ceph_mds_request_head_old *)&new_head->oldest_client_tid;
>> -}
>> -
>>   /*
>>    * called under mdsc->mutex
>>    */
>> @@ -3136,30 +3156,26 @@ static int __prepare_send_request(struct ceph_mds_session *session,
>>          int mds = session->s_mds;
>>          struct ceph_mds_client *mdsc = session->s_mdsc;
>>          struct ceph_client *cl = mdsc->fsc->client;
>> -       struct ceph_mds_request_head_old *rhead;
>> +       struct ceph_mds_request_head_legacy *lhead;
>> +       struct ceph_mds_request_head *nhead;
>>          struct ceph_msg *msg;
>> -       int flags = 0, max_retry;
>> +       int flags = 0, old_max_retry;
>> +       bool old_version = !test_bit(CEPHFS_FEATURE_32BITS_RETRY_FWD, &session->s_features);
>>
>> -       /*
>> -        * The type of 'r_attempts' in kernel 'ceph_mds_request'
>> -        * is 'int', while in 'ceph_mds_request_head' the type of
>> -        * 'num_retry' is '__u8'. So in case the request retries
>> -        *  exceeding 256 times, the MDS will receive a incorrect
>> -        *  retry seq.
>> -        *
>> -        * In this case it's ususally a bug in MDS and continue
>> -        * retrying the request makes no sense.
>> -        *
>> -        * In future this could be fixed in ceph code, so avoid
>> -        * using the hardcode here.
>> +       /* Avoid inifinite retrying after overflow. The client will
>> +        * increase the retry count and if the MDS is old version,
>> +        * so we limit to retry at most 256 times.
>>           */
>> -       max_retry = sizeof_field(struct ceph_mds_request_head, num_retry);
>> -       max_retry = 1 << (max_retry * BITS_PER_BYTE);
>> -       if (req->r_attempts >= max_retry) {
>> -               pr_warn_ratelimited_client(cl, "request tid %llu seq overflow\n",
>> -                                          req->r_tid);
>> -               return -EMULTIHOP;
>> -       }
>> +       if (req->r_attempts) {
>> +               old_max_retry = sizeof_field(struct ceph_mds_request_head_old, num_retry);
>> +               old_max_retry = 1 << (old_max_retry * BITS_PER_BYTE);
>> +               if ((old_version && req->r_attempts >= old_max_retry) ||
>> +                   ((uint32_t)req->r_attempts >= U32_MAX)) {
>> +                       pr_warn_ratelimited_client(cl, "%s request tid %llu seq overflow\n",
>> +                                                 __func__, req->r_tid);
>> +                       return -EMULTIHOP;
>> +               }
>> +        }
>>
>>          req->r_attempts++;
>>          if (req->r_inode) {
>> @@ -3184,20 +3200,24 @@ static int __prepare_send_request(struct ceph_mds_session *session,
>>                   * d_move mangles the src name.
>>                   */
>>                  msg = req->r_request;
>> -               rhead = find_old_request_head(msg->front.iov_base,
>> -                                             session->s_con.peer_features);
>> +               lhead = find_legacy_request_head(msg->front.iov_base,
>> +                                                session->s_con.peer_features);
>>
>> -               flags = le32_to_cpu(rhead->flags);
>> +               flags = le32_to_cpu(lhead->flags);
>>                  flags |= CEPH_MDS_FLAG_REPLAY;
>> -               rhead->flags = cpu_to_le32(flags);
>> +               lhead->flags = cpu_to_le32(flags);
>>
>>                  if (req->r_target_inode)
>> -                       rhead->ino = cpu_to_le64(ceph_ino(req->r_target_inode));
>> +                       lhead->ino = cpu_to_le64(ceph_ino(req->r_target_inode));
>>
>> -               rhead->num_retry = req->r_attempts - 1;
>> +               lhead->num_retry = req->r_attempts - 1;
>> +               if (!old_version) {
>> +                       nhead = (struct ceph_mds_request_head*)msg->front.iov_base;
>> +                       nhead->ext_num_retry = cpu_to_le32(req->r_attempts - 1);
>> +               }
>>
>>                  /* remove cap/dentry releases from message */
>> -               rhead->num_releases = 0;
>> +               lhead->num_releases = 0;
>>
>>                  p = msg->front.iov_base + req->r_request_release_offset;
>>                  encode_mclientrequest_tail(&p, req);
>> @@ -3218,18 +3238,23 @@ static int __prepare_send_request(struct ceph_mds_session *session,
>>          }
>>          req->r_request = msg;
>>
>> -       rhead = find_old_request_head(msg->front.iov_base,
>> -                                     session->s_con.peer_features);
>> -       rhead->oldest_client_tid = cpu_to_le64(__get_oldest_tid(mdsc));
>> +       lhead = find_legacy_request_head(msg->front.iov_base,
>> +                                        session->s_con.peer_features);
>> +       lhead->oldest_client_tid = cpu_to_le64(__get_oldest_tid(mdsc));
>>          if (test_bit(CEPH_MDS_R_GOT_UNSAFE, &req->r_req_flags))
>>                  flags |= CEPH_MDS_FLAG_REPLAY;
>>          if (test_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags))
>>                  flags |= CEPH_MDS_FLAG_ASYNC;
>>          if (req->r_parent)
>>                  flags |= CEPH_MDS_FLAG_WANT_DENTRY;
>> -       rhead->flags = cpu_to_le32(flags);
>> -       rhead->num_fwd = req->r_num_fwd;
>> -       rhead->num_retry = req->r_attempts - 1;
>> +       lhead->flags = cpu_to_le32(flags);
>> +       lhead->num_fwd = req->r_num_fwd;
>> +       lhead->num_retry = req->r_attempts - 1;
>> +       if (!old_version) {
>> +               nhead = (struct ceph_mds_request_head*)msg->front.iov_base;
>> +               nhead->ext_num_fwd = cpu_to_le32(req->r_num_fwd);
>> +               nhead->ext_num_retry = cpu_to_le32(req->r_attempts - 1);
>> +       }
>>
>>          doutc(cl, " r_parent = %p\n", req->r_parent);
>>          return 0;
>> @@ -3893,34 +3918,20 @@ static void handle_forward(struct ceph_mds_client *mdsc,
>>          if (test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags)) {
>>                  doutc(cl, "forward tid %llu aborted, unregistering\n", tid);
>>                  __unregister_request(mdsc, req);
>> -       } else if (fwd_seq <= req->r_num_fwd) {
>> -               /*
>> -                * The type of 'num_fwd' in ceph 'MClientRequestForward'
>> -                * is 'int32_t', while in 'ceph_mds_request_head' the
>> -                * type is '__u8'. So in case the request bounces between
>> -                * MDSes exceeding 256 times, the client will get stuck.
>> -                *
>> -                * In this case it's ususally a bug in MDS and continue
>> -                * bouncing the request makes no sense.
>> +       } else if (fwd_seq <= req->r_num_fwd || (uint32_t)fwd_seq >= U32_MAX) {
>> +               /* Avoid inifinite retrying after overflow.
>>                   *
>> -                * In future this could be fixed in ceph code, so avoid
>> -                * using the hardcode here.
>> +                * The MDS will increase the fwd count and in client side
>> +                * if the num_fwd is less than the one saved in request
>> +                * that means the MDS is an old version and overflowed of
>> +                * 8 bits.
>>                   */
>> -               int max = sizeof_field(struct ceph_mds_request_head, num_fwd);
>> -               max = 1 << (max * BITS_PER_BYTE);
>> -               if (req->r_num_fwd >= max) {
>> -                       mutex_lock(&req->r_fill_mutex);
>> -                       req->r_err = -EMULTIHOP;
>> -                       set_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags);
>> -                       mutex_unlock(&req->r_fill_mutex);
>> -                       aborted = true;
>> -                       pr_warn_ratelimited_client(cl,
>> -                                       "forward tid %llu seq overflow\n",
>> -                                       tid);
>> -               } else {
>> -                       doutc(cl, "forward tid %llu to mds%d - old seq %d <= %d\n",
>> -                             tid, next_mds, req->r_num_fwd, fwd_seq);
>> -               }
>> +               mutex_lock(&req->r_fill_mutex);
>> +               req->r_err = -EMULTIHOP;
>> +               set_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags);
>> +               mutex_unlock(&req->r_fill_mutex);
>> +               aborted = true;
>> +               pr_warn_ratelimited_client(cl, "forward tid %llu seq overflow\n", tid);
>>          } else {
>>                  /* resend. forward race not possible; mds would drop */
>>                  doutc(cl, "forward tid %llu to mds%d (we resend)\n", tid, next_mds);
>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>> index befbd384428e..717a7399bacb 100644
>> --- a/fs/ceph/mds_client.h
>> +++ b/fs/ceph/mds_client.h
>> @@ -32,8 +32,9 @@ enum ceph_feature_type {
>>          CEPHFS_FEATURE_ALTERNATE_NAME,
>>          CEPHFS_FEATURE_NOTIFY_SESSION_STATE,
>>          CEPHFS_FEATURE_OP_GETVXATTR,
>> +       CEPHFS_FEATURE_32BITS_RETRY_FWD,
>>
>> -       CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_OP_GETVXATTR,
>> +       CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_32BITS_RETRY_FWD,
>>   };
>>
>>   #define CEPHFS_FEATURES_CLIENT_SUPPORTED {     \
>> @@ -47,6 +48,7 @@ enum ceph_feature_type {
>>          CEPHFS_FEATURE_ALTERNATE_NAME,          \
>>          CEPHFS_FEATURE_NOTIFY_SESSION_STATE,    \
>>          CEPHFS_FEATURE_OP_GETVXATTR,            \
>> +       CEPHFS_FEATURE_32BITS_RETRY_FWD,        \
>>   }
>>
>>   /*
>> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
>> index 45f8ce61e103..f3b3593254b9 100644
>> --- a/include/linux/ceph/ceph_fs.h
>> +++ b/include/linux/ceph/ceph_fs.h
>> @@ -484,7 +484,7 @@ union ceph_mds_request_args_ext {
>>   #define CEPH_MDS_FLAG_WANT_DENTRY      2 /* want dentry in reply */
>>   #define CEPH_MDS_FLAG_ASYNC            4 /* request is asynchronous */
>>
>> -struct ceph_mds_request_head_old {
>> +struct ceph_mds_request_head_legacy {
>>          __le64 oldest_client_tid;
>>          __le32 mdsmap_epoch;           /* on client */
>>          __le32 flags;                  /* CEPH_MDS_FLAG_* */
>> @@ -497,9 +497,9 @@ struct ceph_mds_request_head_old {
>>          union ceph_mds_request_args args;
>>   } __attribute__ ((packed));
>>
>> -#define CEPH_MDS_REQUEST_HEAD_VERSION  1
>> +#define CEPH_MDS_REQUEST_HEAD_VERSION  2
>>
>> -struct ceph_mds_request_head {
>> +struct ceph_mds_request_head_old {
>>          __le16 version;                /* struct version */
>>          __le64 oldest_client_tid;
>>          __le32 mdsmap_epoch;           /* on client */
>> @@ -513,6 +513,23 @@ struct ceph_mds_request_head {
>>          union ceph_mds_request_args_ext args;
>>   } __attribute__ ((packed));
>>
>> +struct ceph_mds_request_head {
>> +       __le16 version;                /* struct version */
>> +       __le64 oldest_client_tid;
>> +       __le32 mdsmap_epoch;           /* on client */
>> +       __le32 flags;                  /* CEPH_MDS_FLAG_* */
>> +       __u8 num_retry, num_fwd;       /* legacy count retry and fwd attempts */
>> +       __le16 num_releases;           /* # include cap/lease release records */
>> +       __le32 op;                     /* mds op code */
>> +       __le32 caller_uid, caller_gid;
>> +       __le64 ino;                    /* use this ino for openc, mkdir, mknod,
>> +                                         etc. (if replaying) */
>> +       union ceph_mds_request_args_ext args;
>> +
>> +       __le32 ext_num_retry;          /* new count retry attempts */
>> +       __le32 ext_num_fwd;            /* new count fwd attempts */
>> +} __attribute__ ((packed));
>> +
>>   /* cap/lease release record */
>>   struct ceph_mds_request_release {
>>          __le64 ino, cap_id;            /* ino and unique cap id */
>> --
>> 2.40.1
>>

