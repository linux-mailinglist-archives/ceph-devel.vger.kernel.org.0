Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBE4815A6DA
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Feb 2020 11:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbgBLKqf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Feb 2020 05:46:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39725 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727347AbgBLKqf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Feb 2020 05:46:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581504394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cFzZ08QSb15fq0hZwT6Z1YPB0E8hkgG6XFCVNwDOOWM=;
        b=I+uZtmMH8Dm9XIdG5mMxAPHDsstohMAkOHlXp9nH4eM6yQql8sCKBHG0aDC76asssTphKB
        7IfkKoE/lwHnZMs9X73mTcbIX8MXwTWUEI+LSl4LwQGRjcSkiDTBAUaegap5OrQXDzQKG/
        KIIQNTfHYIMLXauJcERkb6PqsHeesOs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-PTNXpo6nNQyvMsT3yI6MDw-1; Wed, 12 Feb 2020 05:46:32 -0500
X-MC-Unique: PTNXpo6nNQyvMsT3yI6MDw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7442ADB20;
        Wed, 12 Feb 2020 10:46:31 +0000 (UTC)
Received: from [10.72.12.209] (ovpn-12-209.pek2.redhat.com [10.72.12.209])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D934D5C1B0;
        Wed, 12 Feb 2020 10:46:26 +0000 (UTC)
Subject: Re: [PATCH] ceph: remove CEPH_MOUNT_OPT_FSCACHE flag
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20200212082435.18118-1-xiubli@redhat.com>
 <CAOi1vP88LOiZ051+xNkPTaxb0Z=iM=Ygs=reW3EQwOyRpyON0A@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <90399165-9a54-f7c9-d9d3-ad08f6919496@redhat.com>
Date:   Wed, 12 Feb 2020 18:46:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <CAOi1vP88LOiZ051+xNkPTaxb0Z=iM=Ygs=reW3EQwOyRpyON0A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/12 17:59, Ilya Dryomov wrote:
> On Wed, Feb 12, 2020 at 9:24 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Since we can figure out whether the fscache is enabled or not by
>> using the fscache_uniq and this flag is redundant.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/super.c | 9 +++------
>>   fs/ceph/super.h | 9 ++++-----
>>   2 files changed, 7 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>> index 48f86eb82b9b..8df506dd9039 100644
>> --- a/fs/ceph/super.c
>> +++ b/fs/ceph/super.c
>> @@ -383,10 +383,7 @@ static int ceph_parse_mount_param(struct fs_context *fc,
>>   #ifdef CONFIG_CEPH_FSCACHE
>>                  kfree(fsopt->fscache_uniq);
>>                  fsopt->fscache_uniq = NULL;
>> -               if (result.negated) {
>> -                       fsopt->flags &= ~CEPH_MOUNT_OPT_FSCACHE;
>> -               } else {
>> -                       fsopt->flags |= CEPH_MOUNT_OPT_FSCACHE;
>> +               if (!result.negated) {
>>                          fsopt->fscache_uniq = param->string;
>>                          param->string = NULL;
>>                  }
>> @@ -605,7 +602,7 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
>>                  seq_puts(m, ",nodcache");
>>          if (fsopt->flags & CEPH_MOUNT_OPT_INO32)
>>                  seq_puts(m, ",ino32");
>> -       if (fsopt->flags & CEPH_MOUNT_OPT_FSCACHE) {
>> +       if (fsopt->fscache_uniq) {
>>                  seq_show_option(m, "fsc", fsopt->fscache_uniq);
>>          }
>>          if (fsopt->flags & CEPH_MOUNT_OPT_NOPOOLPERM)
>> @@ -969,7 +966,7 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc,
>>                          goto out;
>>
>>                  /* setup fscache */
>> -               if (fsc->mount_options->flags & CEPH_MOUNT_OPT_FSCACHE) {
>> +               if (fsc->mount_options->fscache_uniq) {
>>                          err = ceph_fscache_register_fs(fsc, fc);
>>                          if (err < 0)
>>                                  goto out;
>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index ebc25072b19b..ad44b98f3c3b 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -38,11 +38,10 @@
>>   #define CEPH_MOUNT_OPT_NOASYNCREADDIR  (1<<7) /* no dcache readdir */
>>   #define CEPH_MOUNT_OPT_INO32           (1<<8) /* 32 bit inos */
>>   #define CEPH_MOUNT_OPT_DCACHE          (1<<9) /* use dcache for readdir etc */
>> -#define CEPH_MOUNT_OPT_FSCACHE         (1<<10) /* use fscache */
>> -#define CEPH_MOUNT_OPT_NOPOOLPERM      (1<<11) /* no pool permission check */
>> -#define CEPH_MOUNT_OPT_MOUNTWAIT       (1<<12) /* mount waits if no mds is up */
>> -#define CEPH_MOUNT_OPT_NOQUOTADF       (1<<13) /* no root dir quota in statfs */
>> -#define CEPH_MOUNT_OPT_NOCOPYFROM      (1<<14) /* don't use RADOS 'copy-from' op */
>> +#define CEPH_MOUNT_OPT_NOPOOLPERM      (1<<10) /* no pool permission check */
>> +#define CEPH_MOUNT_OPT_MOUNTWAIT       (1<<11) /* mount waits if no mds is up */
>> +#define CEPH_MOUNT_OPT_NOQUOTADF       (1<<12) /* no root dir quota in statfs */
>> +#define CEPH_MOUNT_OPT_NOCOPYFROM      (1<<13) /* don't use RADOS 'copy-from' op */
>>
>>   #define CEPH_MOUNT_OPT_DEFAULT                 \
>>          (CEPH_MOUNT_OPT_DCACHE |                \
> Hi Xiubo,
>
> Did you test this both with and without supplying a uniquifier (i.e.
> both "-o fsc=<uniquifier>" and "-o fsc" cases?  I'm pretty sure this
> breaks "-o fsc" case...

Yeah, it seems will.

Thanks,

BRs

> Thanks,
>
>                  Ilya
>

