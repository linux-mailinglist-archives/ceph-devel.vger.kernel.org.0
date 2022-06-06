Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED7453E86A
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jun 2022 19:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238818AbiFFNVu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jun 2022 09:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238804AbiFFNVn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Jun 2022 09:21:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8140D2E6EC5
        for <ceph-devel@vger.kernel.org>; Mon,  6 Jun 2022 06:21:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF8EA61268
        for <ceph-devel@vger.kernel.org>; Mon,  6 Jun 2022 13:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1AECC3411D;
        Mon,  6 Jun 2022 13:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654521701;
        bh=t0HMesijZ59biNI7iomWN6mqO0A8EKGR5ZokIYgW16o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aCAjNhu4qNehwZH2lpxV5PJlDPwukHPUSYvfpBJS0zgLdMtEy0cZHZbxwbSE4daBE
         j9YePIdJlY3QsDEghbRTBw3W5xzyleR1r6fTOQ47YwkXjNGDTaNeNkwreItIEcfvpe
         f+en4c/FSTP2q3VDw8Mq6SSeFeAVYnR5aVLmWTjghn33AnjbQTWfkqllRtt2SWXZDC
         bXUC1YKXaZY4BXTiD1noQAkxKUEByBnYBsnSnkKGSIipKPbdT0sDxRstF1EGpKUdQg
         344cLJ67pc36NidvLuwLUjTulC3VSMMAvuHAg1xpBg0+yY0PrCbLdj03au+78RbofT
         +T8IZjnr1rsSg==
Message-ID: <072ec646d68caf634c812e037b0364ae29f1d1d6.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: fix the incorrect comment for the
 ceph_mds_caps struct
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, idryomov@gmail.com
Cc:     lhenriques@suse.de, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 06 Jun 2022 09:21:39 -0400
In-Reply-To: <20220606131340.317483-1-xiubli@redhat.com>
References: <20220606131340.317483-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2022-06-06 at 21:13 +0800, Xiubo Li wrote:
> The incorrect comment is misleading. Acutally the last members
> in ceph_mds_caps strcut is a union for none export and export
> bodies.
>=20
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  include/linux/ceph/ceph_fs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index 86bf82dbd8b8..40740e234ce1 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -768,7 +768,7 @@ struct ceph_mds_caps {
>  	__le32 xattr_len;
>  	__le64 xattr_version;
> =20
> -	/* filelock */
> +	/* a union of non-export and export bodies. */
>  	__le64 size, max_size, truncate_size;
>  	__le32 truncate_seq;
>  	struct ceph_timespec mtime, atime, ctime;

Reviewed-by: Jeff Layton <jlayton@kernel.org>
