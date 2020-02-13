Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA2AB15B6D6
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2020 02:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729467AbgBMBsy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Feb 2020 20:48:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48092 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729289AbgBMBsx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Feb 2020 20:48:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581558532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gz2jU4lPA1C4bCqI3Cf8tIETjdKHMg6bzOswq9Gm9ds=;
        b=KyFPZierGvqHiZeYJeb5eGWybwvl+AW0c2KJ4EfUq59UL9V8oYuVOIXFnIdgwP1lcZmKnT
        jd5RxsyY5l/ncAt8RK9TcGUYlwzucMfAGtZo4yJKBRIRPeKHMsB7HW3UFecUcXjnRdSUD3
        6YihAXRSDp0cXKFOjM11S+7XimDc1E0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-RKgHTEu3PDG-0fFTYk4BFw-1; Wed, 12 Feb 2020 20:48:50 -0500
X-MC-Unique: RKgHTEu3PDG-0fFTYk4BFw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A12E8010DF;
        Thu, 13 Feb 2020 01:48:49 +0000 (UTC)
Received: from [10.72.12.209] (ovpn-12-209.pek2.redhat.com [10.72.12.209])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F25721001920;
        Thu, 13 Feb 2020 01:48:44 +0000 (UTC)
Subject: Re: [PATCH] ceph: fs add reconfiguring superblock parameters support
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20200212085454.35665-1-xiubli@redhat.com>
 <c2571e75d3fe3f37ea77c5b1acaa5e3dcc45cb2b.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <bcfb8841-dbae-e9cc-b509-c8b7a77dc337@redhat.com>
Date:   Thu, 13 Feb 2020 09:48:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <c2571e75d3fe3f37ea77c5b1acaa5e3dcc45cb2b.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/12 20:01, Jeff Layton wrote:
> On Wed, 2020-02-12 at 03:54 -0500, xiubli@redhat.com wrote:
[...]
>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>> index 9a21054059f2..8df506dd9039 100644
>> --- a/fs/ceph/super.c
>> +++ b/fs/ceph/super.c
>> @@ -1175,7 +1175,57 @@ static void ceph_free_fc(struct fs_context *fc)
>>  =20
>>   static int ceph_reconfigure_fc(struct fs_context *fc)
>>   {
>> -	sync_filesystem(fc->root->d_sb);
>> +	struct super_block *sb =3D fc->root->d_sb;
>> +	struct ceph_fs_client *fsc =3D ceph_sb_to_client(sb);
>> +	struct ceph_mount_options *fsopt =3D fsc->mount_options;
>> +	struct ceph_parse_opts_ctx *pctx =3D fc->fs_private;
>> +	struct ceph_mount_options *new_fsopt =3D pctx->opts;
>> +	int ret;
>> +
>> +	sync_filesystem(sb);
>> +
>> +	ret =3D ceph_reconfigure_copts(fc, pctx->copts, fsc->client->options=
);
>> +	if (ret)
>> +		return ret;
>> +
>> +	if (new_fsopt->snapdir_name !=3D fsopt->snapdir_name)
>> +		return invalf(fc, "ceph: reconfiguration of snapdir_name not allowe=
d");
>> +
>> +	if (new_fsopt->mds_namespace !=3D fsopt->mds_namespace)
>> +		return invalf(fc, "ceph: reconfiguration of mds_namespace not allow=
ed");
>> +
>> +	if (new_fsopt->wsize !=3D fsopt->wsize)
>> +		return invalf(fc, "ceph: reconfiguration of wsize not allowed");
>> +	if (new_fsopt->rsize !=3D fsopt->rsize)
>> +		return invalf(fc, "ceph: reconfiguration of rsize not allowed");
>> +	if (new_fsopt->rasize !=3D fsopt->rasize)
>> +		return invalf(fc, "ceph: reconfiguration of rasize not allowed");
>> +
> Odd. I would think the wsize, rsize and rasize are things you _could_
> reconfigure at remount time.
>
> In any case, I agree with Ilya. Not everything can be changed on a
> remount. It'd be best to identify some small subset of mount options
> that you do need to allow to be changed, and ensure we can do that.

Checked this again, the wsize/rasize should be okay for this.

But for the rsize, we need to apply the change to the bdi->io_pages,=20
which will be used in the ondemand_readahead(), likes:

392=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
393=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * If the reques=
t exceeds the readahead window, allow the=20
read to
394=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * be up to the =
optimal hardware IO size
395=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
396=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (req_size > max_pa=
ges && bdi->io_pages > max_pages)
397=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 max_pages =3D min(req_size, bdi->io_pages);

For example:

Assume the max_pages =3D 100, req_size =3D 1000, the old bdi->io_pages =3D=
 10.

If the bdi->io_pages get changed from 10 --> 1000, between Line#396 and=20
Line#397, after Line#397 we are expecting to get max_pages =3D 10, but=20
actually we get 1000 instead.

But this should be okay for the page cache readahead stuff, it doesn't=20
matter here, right ? If so we can reconfigure the rsize then.

Thanks.



