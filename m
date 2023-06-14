Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1B372F1F7
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Jun 2023 03:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbjFNBdP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 21:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbjFNBdO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 21:33:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D1BCE
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jun 2023 18:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686706334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wE517duhCg3m+qepxqWHl/PvDM4gAC73PjSTpz1sebg=;
        b=UgvaQurdg+oDmOUKuDduogUoXUEVYnznQ8Q8acIXs6a5xPRcVBBSLzpKIyBaCz+ot+QIi1
        SVsN//RqVGfH/YSzLxbZvUQe/3qxsQLz8lv+74OAzgM5QrbUIimHkeiLw8VOV5y/iKEkVO
        5hWP75IE6GrHFu4sdvOd+ogDkoWgx6U=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-259-644TVikgOA2YH2G2dqjufQ-1; Tue, 13 Jun 2023 21:32:12 -0400
X-MC-Unique: 644TVikgOA2YH2G2dqjufQ-1
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-6b2940e84fdso4504742a34.1
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jun 2023 18:32:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686706332; x=1689298332;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wE517duhCg3m+qepxqWHl/PvDM4gAC73PjSTpz1sebg=;
        b=MFonppVC0rxMAnZBVIk+hxyetOABBg8Md7zK6leN8o7PKNEeP5if+CGR1ZOlxhQ5eb
         MIjjl+xjR7CAwVT8GniZFfPGQvpVtdy8i78WRv164LCVCKo8bLNG1lh+dVOuv3J1jbMi
         DeCBx68wjC7lFDcxMLLe8Nd2mlRHwcrB71QPvetvOjJ2uBa4O7q4wy3T5obFYKIlQzAv
         H6w263nfdQQ/qjdoPq4xCXsHt8U3pPaPZt3u5HVcVTmYNyAVmWAKK85N4dxoE+mb33BA
         98X/37lIFGR19Fe7OPpSa3pl7sDTNfQI3rgwWj+7NW1WmrUuQVnFkxNpyCH3HZeGl8oB
         cYtQ==
X-Gm-Message-State: AC+VfDzW+c7V//HZZ+YRz186AUNrqp2B9GZT4gCdMaDlhg/09HhYiB5B
        60SJeakdVK/M4kaT79BOVygnjQXYPitlC5190EWb8KMsYV6wvNsXgTBECik4CVQRg6Y1CR55JnD
        nSANaVmHeZX19dh5+O4Hhwg==
X-Received: by 2002:a05:6830:104d:b0:6b1:604f:3f22 with SMTP id b13-20020a056830104d00b006b1604f3f22mr12129956otp.2.1686706331797;
        Tue, 13 Jun 2023 18:32:11 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5chaAfuw7S4HahhGtdNETy03XWz1X0EwMhAobgXCyzwxfxbULs89djmhtlPSBIAn/+oI0ycg==
X-Received: by 2002:a05:6830:104d:b0:6b1:604f:3f22 with SMTP id b13-20020a056830104d00b006b1604f3f22mr12129942otp.2.1686706331535;
        Tue, 13 Jun 2023 18:32:11 -0700 (PDT)
Received: from [10.72.12.155] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s12-20020a6550cc000000b0051b460fd90fsm9169213pgp.8.2023.06.13.18.32.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jun 2023 18:32:09 -0700 (PDT)
Message-ID: <d0ea5355-885e-e4ca-0f9b-36841015f39b@redhat.com>
Date:   Wed, 14 Jun 2023 09:31:58 +0800
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
 <de1a2706-5e9a-678f-4c9a-1f1856fb7b4e@redhat.com>
 <CAOi1vP-xoNH7+oo1Rv8i5RGcyhrR8VEM2OBs9hDf-sxTgYhaeQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP-xoNH7+oo1Rv8i5RGcyhrR8VEM2OBs9hDf-sxTgYhaeQ@mail.gmail.com>
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


On 6/14/23 05:50, Ilya Dryomov wrote:
> On Tue, Jun 13, 2023 at 11:51 AM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 6/13/23 17:07, Ilya Dryomov wrote:
>>> On Mon, Jun 12, 2023 at 1:46 PM <xiubli@redhat.com> wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> Multiple cephfs mounts on a host is increasingly common so disambiguating
>>>> messages like this is necessary and will make it easier to debug
>>>> issues.
>>>>
>>>> URL: https://tracker.ceph.com/issues/61590
>>>> Cc: Patrick Donnelly <pdonnell@redhat.com>
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/acl.c        |   6 +-
>>>>    fs/ceph/addr.c       | 300 ++++++++++--------
>>>>    fs/ceph/caps.c       | 709 ++++++++++++++++++++++++-------------------
>>>>    fs/ceph/crypto.c     |  45 ++-
>>>>    fs/ceph/debugfs.c    |   4 +-
>>>>    fs/ceph/dir.c        | 222 +++++++++-----
>>>>    fs/ceph/export.c     |  39 ++-
>>>>    fs/ceph/file.c       | 268 +++++++++-------
>>>>    fs/ceph/inode.c      | 528 ++++++++++++++++++--------------
>>>>    fs/ceph/ioctl.c      |  10 +-
>>>>    fs/ceph/locks.c      |  62 ++--
>>>>    fs/ceph/mds_client.c | 616 +++++++++++++++++++++----------------
>>>>    fs/ceph/mdsmap.c     |  25 +-
>>>>    fs/ceph/metric.c     |   5 +-
>>>>    fs/ceph/quota.c      |  31 +-
>>>>    fs/ceph/snap.c       | 186 +++++++-----
>>>>    fs/ceph/super.c      |  64 ++--
>>>>    fs/ceph/xattr.c      |  97 +++---
>>>>    18 files changed, 1887 insertions(+), 1330 deletions(-)
>>>>
>>>> diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
>>>> index 8a56f979c7cb..970acd07908d 100644
>>>> --- a/fs/ceph/acl.c
>>>> +++ b/fs/ceph/acl.c
>>>> @@ -15,6 +15,7 @@
>>>>    #include <linux/slab.h>
>>>>
>>>>    #include "super.h"
>>>> +#include "mds_client.h"
>>>>
>>>>    static inline void ceph_set_cached_acl(struct inode *inode,
>>>>                                           int type, struct posix_acl *acl)
>>>> @@ -31,6 +32,7 @@ static inline void ceph_set_cached_acl(struct inode *inode,
>>>>
>>>>    struct posix_acl *ceph_get_acl(struct inode *inode, int type, bool rcu)
>>>>    {
>>>> +       struct ceph_client *cl = ceph_inode_to_client(inode);
>>>>           int size;
>>>>           unsigned int retry_cnt = 0;
>>>>           const char *name;
>>>> @@ -72,8 +74,8 @@ struct posix_acl *ceph_get_acl(struct inode *inode, int type, bool rcu)
>>>>           } else if (size == -ENODATA || size == 0) {
>>>>                   acl = NULL;
>>>>           } else {
>>>> -               pr_err_ratelimited("get acl %llx.%llx failed, err=%d\n",
>>>> -                                  ceph_vinop(inode), size);
>>>> +               pr_err_ratelimited_client(cl, "%s %llx.%llx failed, err=%d\n",
>>>> +                                         __func__, ceph_vinop(inode), size);
>>>>                   acl = ERR_PTR(-EIO);
>>>>           }
>>>>
>>>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>>>> index e62318b3e13d..c772639dc0cb 100644
>>>> --- a/fs/ceph/addr.c
>>>> +++ b/fs/ceph/addr.c
>>>> @@ -79,18 +79,18 @@ static inline struct ceph_snap_context *page_snap_context(struct page *page)
>>>>     */
>>>>    static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
>>>>    {
>>>> -       struct inode *inode;
>>>> +       struct inode *inode = mapping->host;
>>>> +       struct ceph_client *cl = ceph_inode_to_client(inode);
>>>>           struct ceph_inode_info *ci;
>>>>           struct ceph_snap_context *snapc;
>>>>
>>>>           if (folio_test_dirty(folio)) {
>>>> -               dout("%p dirty_folio %p idx %lu -- already dirty\n",
>>>> -                    mapping->host, folio, folio->index);
>>>> +               dout_client(cl, "%s %llx.%llx %p idx %lu -- already dirty\n",
>>>> +                           __func__, ceph_vinop(inode), folio, folio->index);
>>> While having context information attached to each dout is nice, it
>>> certainly comes at a price of a lot of churn and automated backport
>>> disruption.
>> Yeah, certainly this will break automated backporting. But this should
>> be okay, I can generate the backport patches for each stable release for
>> this patch series, so after this it will make the automated backporting
>> work.
>>
>>>    I wonder how much value doing this for douts as opposed
>>> to just pr_* messages actually brings?
>> I think the 'dout()' was introduced by printing more context info, which
>> includes module/function names and line#, when the
>> CONFIG_CEPH_LIB_PRETTYDEBUG is enabled.
> dout() is just a wrapper around pr_debug().  It doesn't have anything
> to do with CONFIG_CEPH_LIB_PRETTYDEBUG per se which adds file names and
> line numbers.  IIRC dout() by itself just adds a space at the front to
> make debugging spew stand out.
>
>> Maybe we can remove CONFIG_CEPH_LIB_PRETTYDEBUG now, since the pr_* will
>> print the module name and also the caller for dout() and pr_* will print
>> the function name mostly ?
> To the best of my knowledge, CONFIG_CEPH_LIB_PRETTYDEBUG has always
> been disabled by default and it's not enabled by any distribution in
> their kernels.  I don't think anyone out there would miss it, but then
> it's not hurting either -- it's less than 20 lines of code with all
> ifdef-ery included.

Okay. I won't touch it.

Thanks


> Thanks,
>
>                  Ilya
>

