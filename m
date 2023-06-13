Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F043D72DE4A
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 11:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235212AbjFMJwK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 05:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234891AbjFMJwH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 05:52:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3563810DF
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jun 2023 02:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686649882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=taunM8zW3gnSE8xvzLbFHH5fP463RkHaq/fiw5xTeY4=;
        b=e6UnTSSKb4oOYd7u/UmZYAXQzUjM3y0Cm3R5Dj587I00gmZ+75sDhUQ/NLgPD3FA9eHj7y
        amDiMmlisEXvu6nUNbu7ZhWJMaiC89qs/1RLfJYvxIMKD5JiW+u83f4O8B9F08oaxEifok
        E/w72cZlDErj1LHcM4nd+GyqLzJN4rM=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-KkiwIKE-Ou-_BQYZADh_mQ-1; Tue, 13 Jun 2023 05:51:20 -0400
X-MC-Unique: KkiwIKE-Ou-_BQYZADh_mQ-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-25bf1781882so914703a91.0
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jun 2023 02:51:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686649880; x=1689241880;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=taunM8zW3gnSE8xvzLbFHH5fP463RkHaq/fiw5xTeY4=;
        b=T8ml62KfamNYFOGqAaKpZngDFUHDOvJ0rs1fFUTgnLhZJnTULN8Lk+ubSdjWYvLy78
         XepOdNLXbSJsaoApWuzUBjEJuE9SkvwYHrgoF2g06xedjzgl4MudGhmDWI/fk3d6FxYq
         qIw2dNp6sO66eAoyPM4HCrS/QAy0SayOLAM+GfUEuTZRzXDWf0AAsxcN6Wn2AVX/DigE
         0CBVorW/5AUFIiQIpcFpugi49mNkG8XPoy1qWNRJl2bK4TDbCo/5GtmWDKeKq9pOtsqg
         0cFCuhorDdi8ywDxvLJI243hPDsv6n/+NrGH2TkWCKFy6+lHHL1FhTMFYn4KQ9Q4BObO
         zuDQ==
X-Gm-Message-State: AC+VfDyv13Wcvw5dPKA3/NfiNrXE1gE2AoTlJDiVnuHQU2QVzpaQB2jM
        jID2jP2sp8RRefJcubBOMaSf8Oy0vXMM2Kz+7UNkps1/X7E46ZUkiLCcaGSylx92LZw7IIPWsKj
        NlDf61YJmR2O8EpQ8BYoBDA==
X-Received: by 2002:a17:90b:2345:b0:25b:da7f:9a53 with SMTP id ms5-20020a17090b234500b0025bda7f9a53mr4961816pjb.26.1686649879972;
        Tue, 13 Jun 2023 02:51:19 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4URG2whZSS7G8+xos+AElN+M8rN6YbkvKOfdb/Dnx0wSU0yBzAc7gepq8e4u+Ua4vAHAh61w==
X-Received: by 2002:a17:90b:2345:b0:25b:da7f:9a53 with SMTP id ms5-20020a17090b234500b0025bda7f9a53mr4961803pjb.26.1686649879599;
        Tue, 13 Jun 2023 02:51:19 -0700 (PDT)
Received: from [10.72.12.155] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 15-20020a17090a004f00b0025352448ba9sm11454499pjb.0.2023.06.13.02.51.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jun 2023 02:51:19 -0700 (PDT)
Message-ID: <de1a2706-5e9a-678f-4c9a-1f1856fb7b4e@redhat.com>
Date:   Tue, 13 Jun 2023 17:51:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 6/6] ceph: print the client global_id in all the debug
 logs
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, khiremat@redhat.com, mchangir@redhat.com,
        pdonnell@redhat.com
References: <20230612114359.220895-1-xiubli@redhat.com>
 <20230612114359.220895-7-xiubli@redhat.com>
 <CAOi1vP-ffbAqdRWi5pNButrdmxJzzRyNZOTTixhEtaSSUTC4qA@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP-ffbAqdRWi5pNButrdmxJzzRyNZOTTixhEtaSSUTC4qA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/13/23 17:07, Ilya Dryomov wrote:
> On Mon, Jun 12, 2023 at 1:46 PM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Multiple cephfs mounts on a host is increasingly common so disambiguating
>> messages like this is necessary and will make it easier to debug
>> issues.
>>
>> URL: https://tracker.ceph.com/issues/61590
>> Cc: Patrick Donnelly <pdonnell@redhat.com>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/acl.c        |   6 +-
>>   fs/ceph/addr.c       | 300 ++++++++++--------
>>   fs/ceph/caps.c       | 709 ++++++++++++++++++++++++-------------------
>>   fs/ceph/crypto.c     |  45 ++-
>>   fs/ceph/debugfs.c    |   4 +-
>>   fs/ceph/dir.c        | 222 +++++++++-----
>>   fs/ceph/export.c     |  39 ++-
>>   fs/ceph/file.c       | 268 +++++++++-------
>>   fs/ceph/inode.c      | 528 ++++++++++++++++++--------------
>>   fs/ceph/ioctl.c      |  10 +-
>>   fs/ceph/locks.c      |  62 ++--
>>   fs/ceph/mds_client.c | 616 +++++++++++++++++++++----------------
>>   fs/ceph/mdsmap.c     |  25 +-
>>   fs/ceph/metric.c     |   5 +-
>>   fs/ceph/quota.c      |  31 +-
>>   fs/ceph/snap.c       | 186 +++++++-----
>>   fs/ceph/super.c      |  64 ++--
>>   fs/ceph/xattr.c      |  97 +++---
>>   18 files changed, 1887 insertions(+), 1330 deletions(-)
>>
>> diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
>> index 8a56f979c7cb..970acd07908d 100644
>> --- a/fs/ceph/acl.c
>> +++ b/fs/ceph/acl.c
>> @@ -15,6 +15,7 @@
>>   #include <linux/slab.h>
>>
>>   #include "super.h"
>> +#include "mds_client.h"
>>
>>   static inline void ceph_set_cached_acl(struct inode *inode,
>>                                          int type, struct posix_acl *acl)
>> @@ -31,6 +32,7 @@ static inline void ceph_set_cached_acl(struct inode *inode,
>>
>>   struct posix_acl *ceph_get_acl(struct inode *inode, int type, bool rcu)
>>   {
>> +       struct ceph_client *cl = ceph_inode_to_client(inode);
>>          int size;
>>          unsigned int retry_cnt = 0;
>>          const char *name;
>> @@ -72,8 +74,8 @@ struct posix_acl *ceph_get_acl(struct inode *inode, int type, bool rcu)
>>          } else if (size == -ENODATA || size == 0) {
>>                  acl = NULL;
>>          } else {
>> -               pr_err_ratelimited("get acl %llx.%llx failed, err=%d\n",
>> -                                  ceph_vinop(inode), size);
>> +               pr_err_ratelimited_client(cl, "%s %llx.%llx failed, err=%d\n",
>> +                                         __func__, ceph_vinop(inode), size);
>>                  acl = ERR_PTR(-EIO);
>>          }
>>
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index e62318b3e13d..c772639dc0cb 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -79,18 +79,18 @@ static inline struct ceph_snap_context *page_snap_context(struct page *page)
>>    */
>>   static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
>>   {
>> -       struct inode *inode;
>> +       struct inode *inode = mapping->host;
>> +       struct ceph_client *cl = ceph_inode_to_client(inode);
>>          struct ceph_inode_info *ci;
>>          struct ceph_snap_context *snapc;
>>
>>          if (folio_test_dirty(folio)) {
>> -               dout("%p dirty_folio %p idx %lu -- already dirty\n",
>> -                    mapping->host, folio, folio->index);
>> +               dout_client(cl, "%s %llx.%llx %p idx %lu -- already dirty\n",
>> +                           __func__, ceph_vinop(inode), folio, folio->index);
> While having context information attached to each dout is nice, it
> certainly comes at a price of a lot of churn and automated backport
> disruption.

Yeah, certainly this will break automated backporting. But this should 
be okay, I can generate the backport patches for each stable release for 
this patch series, so after this it will make the automated backporting 
work.

>   I wonder how much value doing this for douts as opposed
> to just pr_* messages actually brings?

I think the 'dout()' was introduced by printing more context info, which 
includes module/function names and line#, when the 
CONFIG_CEPH_LIB_PRETTYDEBUG is enabled.

Maybe we can remove CONFIG_CEPH_LIB_PRETTYDEBUG now, since the pr_* will 
print the module name and also the caller for dout() and pr_* will print 
the function name mostly ?

> A regular user never sees douts as enabling them without extra care
> tends to be useless -- journald can't cope with the volume and quickly
> starts discarding them.  From the developer side, many douts already
> include at least one (hashed) pointer value which is usually sufficient
> to disambiguate, even if it's more cumbersome than a grep on context
> information.

Just in some cases the client global_id is really could help much, 
especially for the issues only could be hit in productions case, which 
could have hundreds of clients, and we can only enable some dout() debug 
logs.

Thanks

- Xiubo

>
> Thanks,
>
>                  Ilya
>

