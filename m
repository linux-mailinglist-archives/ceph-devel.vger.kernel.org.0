Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C278024476B
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Aug 2020 11:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgHNJwo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Fri, 14 Aug 2020 05:52:44 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:58138 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726124AbgHNJwn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 14 Aug 2020 05:52:43 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-236-lAlMELcPNvqeWmJZKrLkDg-1; Fri, 14 Aug 2020 10:52:39 +0100
X-MC-Unique: lAlMELcPNvqeWmJZKrLkDg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 14 Aug 2020 10:52:38 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 14 Aug 2020 10:52:38 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Luis Henriques' <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
CC:     "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ceph: remove unnecessary return in switch statement
Thread-Topic: [PATCH] ceph: remove unnecessary return in switch statement
Thread-Index: AQHWch6rkdainQPrlU66/Hw4ZaLQ6ak3XLCA
Date:   Fri, 14 Aug 2020 09:52:38 +0000
Message-ID: <a1a68d9a887148ae9a80ca103d112e6b@AcuMS.aculab.com>
References: <20200814093822.GA293898@suse.de>
In-Reply-To: <20200814093822.GA293898@suse.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Luis Henriques
> Sent: 14 August 2020 10:38
> 
> Since there's a return immediately after the 'break', there's no need for
> this extra 'return' in the S_IFDIR case.
> 
> Signed-off-by: Luis Henriques <lhenriques@suse.de>
> ---
>  fs/ceph/file.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index d51c3f2fdca0..04ab99c0223a 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -256,8 +256,6 @@ static int ceph_init_file(struct inode *inode, struct file *file, int fmode)
>  	case S_IFDIR:
>  		ret = ceph_init_file_info(inode, file, fmode,
>  						S_ISDIR(inode->i_mode));
> -		if (ret)
> -			return ret;
>  		break;
> 
>  	case S_IFLNK:

I'd move the other way and just do:
		return ceph_init_file_info(...);

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

