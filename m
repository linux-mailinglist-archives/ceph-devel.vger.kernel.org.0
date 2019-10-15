Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF7BAD714A
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Oct 2019 10:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbfJOImI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Oct 2019 04:42:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35262 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726275AbfJOImI (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 04:42:08 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D1FC312A2;
        Tue, 15 Oct 2019 08:42:07 +0000 (UTC)
Received: from [10.72.12.31] (ovpn-12-31.pek2.redhat.com [10.72.12.31])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 20CA95D71C;
        Tue, 15 Oct 2019 08:41:51 +0000 (UTC)
Subject: Re: [PATCH RFC] libceph: remove the useless monc check
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20191015025242.5729-1-xiubli@redhat.com>
 <CAOi1vP-nPhir17mobS3wf8cw4ySeSOoctgnfdcbgKB5OgYtfKg@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <8d69386f-5cbf-1fa6-8908-49d44f1067b0@redhat.com>
Date:   Tue, 15 Oct 2019 16:41:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAOi1vP-nPhir17mobS3wf8cw4ySeSOoctgnfdcbgKB5OgYtfKg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 15 Oct 2019 08:42:07 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/10/15 16:30, Ilya Dryomov wrote:
> On Tue, Oct 15, 2019 at 4:52 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> There is no reason that the con->private will be NULL for mon client,
>> once it is here in dispatch() routine the con->monc->private should
>> already correctly set done. And also just before the dispatch() in
>> try_read() it will also reference the con->monc->private to allocate
>> memory for in_msg.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   net/ceph/mon_client.c | 3 ---
>>   1 file changed, 3 deletions(-)
>>
>> diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
>> index 7256c402ebaa..9d9e4e4ea600 100644
>> --- a/net/ceph/mon_client.c
>> +++ b/net/ceph/mon_client.c
>> @@ -1233,9 +1233,6 @@ static void dispatch(struct ceph_connection *con, struct ceph_msg *msg)
>>          struct ceph_mon_client *monc = con->private;
>>          int type = le16_to_cpu(msg->hdr.type);
>>
>> -       if (!monc)
>> -               return;
>> -
>>          switch (type) {
>>          case CEPH_MSG_AUTH_REPLY:
>>                  handle_auth_reply(monc, msg);
> Hi Xiubo,
>
> I applied the same patch yesterday:

Ah, Cool.

I missed that mail.

Xiubo


> https://github.com/ceph/ceph-client/commit/dd6b2054abec7e9a50c330619b870a018a5fd718
>
> Thanks,
>
>                  Ilya


