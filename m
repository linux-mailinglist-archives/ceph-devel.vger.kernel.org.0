Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCA01587B7
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Feb 2020 02:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbgBKBJ7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 10 Feb 2020 20:09:59 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24535 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727398AbgBKBJ7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 20:09:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581383398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O4abwVgXGlPIiK7CtN33QySZr6Zzn82+3eqGHq5lXL4=;
        b=VOd/VAzH2MbSt83O0IxOQmtw1KdAHFmeCpuPfnvDKpt4D6dTJwZdEB00vCPuag/lN1Yzfc
        2i53NfGoxSGQEYfPeSPlcvaWTqHjt+i49w0GgFyU6o8f+9XxQmpy9zWAwcbsTZefQmlln+
        tZbKM91XByleUyJyynItldxnFDZpj74=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-sJCMZdt-PhCCrJSuc77-DA-1; Mon, 10 Feb 2020 20:09:56 -0500
X-MC-Unique: sJCMZdt-PhCCrJSuc77-DA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0021B13E5;
        Tue, 11 Feb 2020 01:09:54 +0000 (UTC)
Received: from [10.72.12.34] (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B7EF60BF4;
        Tue, 11 Feb 2020 01:09:50 +0000 (UTC)
Subject: Re: [PATCH] ceph: fix posix acl couldn't be settable
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20200210135841.21177-1-xiubli@redhat.com>
 <e2614ef4-7dc1-d9ac-752a-d48b806dd561@redhat.com>
 <CAOi1vP9Pw+=JGJsBLphO44j9RYu=O11VsgJs3fJGG1=gT=Q0UA@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <6aa4147c-68db-c030-8432-c1c42926adec@redhat.com>
Date:   Tue, 11 Feb 2020 09:09:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP9Pw+=JGJsBLphO44j9RYu=O11VsgJs3fJGG1=gT=Q0UA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/11 3:45, Ilya Dryomov wrote:
> On Mon, Feb 10, 2020 at 3:52 PM Xiubo Li <xiubli@redhat.com> wrote:
>> On 2020/2/10 21:58, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> For the old mount API, the module parameters parseing function will
>>> be called in ceph_mount() and also just after the default posix acl
>>> flag set, so we can control to enable/disable it via the mount option.
>>>
>>> But for the new mount API, it will call the module parameters
>>> parseing function before ceph_get_tree(), so the posix acl will always
>>> be enabled.
>>>
>>> Fixes: 82995cc6c5ae ("libceph, rbd, ceph: convert to use the new mount API")
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>>    fs/ceph/super.c | 8 ++++----
>>>    1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>>> index 5fef4f59e13e..69fa498391dc 100644
>>> --- a/fs/ceph/super.c
>>> +++ b/fs/ceph/super.c
>>> @@ -341,6 +341,10 @@ static int ceph_parse_mount_param(struct fs_context *fc,
>>>        unsigned int mode;
>>>        int token, ret;
>>>
>>> +#ifdef CONFIG_CEPH_FS_POSIX_ACL
>>> +     fc->sb_flags |= SB_POSIXACL;
>>> +#endif
>>> +
>> Maybe we should move this to ceph_init_fs_context().
> Hi Xiubo,
>
> Yes -- so it is together with fsopt defaults.
>
Okay, will fix it.

Thanks.



