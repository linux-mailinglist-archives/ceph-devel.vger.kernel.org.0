Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA0E416F493
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Feb 2020 01:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729540AbgBZA6R (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Feb 2020 19:58:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45142 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729277AbgBZA6Q (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Feb 2020 19:58:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582678695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qz7tjkqi4TR+lxoSagtQySul5Wcazk5GvBlgLLT/kwU=;
        b=E203hLRH31fFRVTioAVIgHkHobOWktxBLq2bBLya45/zrUxpHm62dLXQ4C+OpaYkte3keu
        IBBpa8XZtDfaqIae9jdypfZP3hFnu+ThuRS/HDfzQzIoeRuJxusknIZFZqjJxK6Yb5ians
        +GAv1K8w9mH0Wq8uGArX9TYLqR9Y1L0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-Czp_3YuVM16_-QmywrNynQ-1; Tue, 25 Feb 2020 19:58:10 -0500
X-MC-Unique: Czp_3YuVM16_-QmywrNynQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71EDB18A8C97;
        Wed, 26 Feb 2020 00:58:09 +0000 (UTC)
Received: from [10.72.12.161] (ovpn-12-161.pek2.redhat.com [10.72.12.161])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C60B6100164D;
        Wed, 26 Feb 2020 00:58:04 +0000 (UTC)
Subject: Re: [PATCH] ceph: show more detail logs during mount
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20200225033013.4832-1-xiubli@redhat.com>
 <CAOi1vP8J9UaTM+FLHuBVoy_O4mwc=+VK0sCjA=VpAwPhBWBLiw@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <dba7ea1c-334b-4302-2a9c-0f8fa4f8afcb@redhat.com>
Date:   Wed, 26 Feb 2020 08:58:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAOi1vP8J9UaTM+FLHuBVoy_O4mwc=+VK0sCjA=VpAwPhBWBLiw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/25 18:39, Ilya Dryomov wrote:
> On Tue, Feb 25, 2020 at 4:30 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Print the logs in error level to give a helpful hint to make it
>> more user-friendly to debug.
>>
>> URL: https://tracker.ceph.com/issues/44215
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/super.c       | 8 ++++++--
>>   net/ceph/mon_client.c | 2 ++
>>   2 files changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>> index c7f150686a53..e33c2f86647b 100644
>> --- a/fs/ceph/super.c
>> +++ b/fs/ceph/super.c
>> @@ -905,8 +905,10 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc,
>>                                       fsc->mount_options->server_path + 1 : "";
>>
>>                  err = __ceph_open_session(fsc->client, started);
>> -               if (err < 0)
>> +               if (err < 0) {
>> +                       pr_err("mount joining the ceph cluster fail %d\n", err);
>>                          goto out;
>> +               }
>>
>>                  /* setup fscache */
>>                  if (fsc->mount_options->flags & CEPH_MOUNT_OPT_FSCACHE) {
>> @@ -922,6 +924,8 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc,
>>                  root = open_root_dentry(fsc, path, started);
>>                  if (IS_ERR(root)) {
>>                          err = PTR_ERR(root);
>> +                       pr_err("mount opening the root directory fail %d\n",
>> +                              err);
> Hi Xiubo,
>
> Given that these are new user-level filesystem log messages, they
> should probably go into fs_context log.

Yeah, will fix it.


>
>>                          goto out;
>>                  }
>>                  fsc->sb->s_root = dget(root);
>> @@ -1079,7 +1083,7 @@ static int ceph_get_tree(struct fs_context *fc)
>>
>>   out_splat:
>>          if (!ceph_mdsmap_is_cluster_available(fsc->mdsc->mdsmap)) {
>> -               pr_info("No mds server is up or the cluster is laggy\n");
>> +               pr_err("No mds server is up or the cluster is laggy\n");
>>                  err = -EHOSTUNREACH;
>>          }
> If you are changing this one, it should be directed to fs_context log
> as well.
Will do it.
>> diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
>> index 9d9e4e4ea600..6f1372f5f2a7 100644
>> --- a/net/ceph/mon_client.c
>> +++ b/net/ceph/mon_client.c
>> @@ -1179,6 +1179,8 @@ static void handle_auth_reply(struct ceph_mon_client *monc,
>>
>>          if (ret < 0) {
>>                  monc->client->auth_err = ret;
>> +               pr_err("authenticate fail on mon%d %s\n", monc->cur_mon,
>> +                       ceph_pr_addr(&monc->con.peer_addr));
> I don't think this is needed.  Authentication errors are already logged
> in ceph_handle_auth_reply().

Yeah, it is, here just want to give more messages, such as the monX. But 
it is not necessary. So I will delete it.

Thanks Ilya.

BRs

> Thanks,
>
>                  Ilya
>

