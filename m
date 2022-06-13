Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 800B854999E
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Jun 2022 19:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235093AbiFMRP5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Jun 2022 13:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241589AbiFMRPd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 13 Jun 2022 13:15:33 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F70527CDC;
        Mon, 13 Jun 2022 05:24:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2D4901F38A;
        Mon, 13 Jun 2022 12:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655123086; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YynRhdIgv4jshvoQMDKaLLWZty7Q3kDdQhQ5gNO+StM=;
        b=vNg/5nrkq0c+CTbZ04/gpcf2tLJw3ytsoFQGr+EReCd1GklnLby9os7HwkhSR1OcFbGTr7
        aGUnICovRz1QiOq4FKp4yUKc1Ff6DC73bjgca0o8ItQ88AFk9tKEMMoukeVIkDLsOdBbaJ
        be7z1CltSvNz1N2oeVf+K/PP5dJospk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655123086;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YynRhdIgv4jshvoQMDKaLLWZty7Q3kDdQhQ5gNO+StM=;
        b=kmaaZvfaq7yYNso/8Nw9EQjqVLWL+Kj4k+cUZJNz4ejN64ov2VygVFj4PVe/WnvyAKwqsg
        T+8DvYHyIQrkGDCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C9A3213443;
        Mon, 13 Jun 2022 12:24:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4W++L40sp2LxEAAAMHmgww
        (envelope-from <ddiss@suse.de>); Mon, 13 Jun 2022 12:24:45 +0000
Date:   Mon, 13 Jun 2022 14:24:44 +0200
From:   David Disseldorp <ddiss@suse.de>
To:     =?UTF-8?B?THXDrXM=?= Henriques <lhenriques@suse.de>
Cc:     fstests@vger.kernel.org, Zorro Lang <zlang@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] generic/486: adjust the max xattr size
Message-ID: <20220613142444.3276dfa8@suse.de>
In-Reply-To: <20220613113142.4338-3-lhenriques@suse.de>
References: <20220613113142.4338-1-lhenriques@suse.de>
        <20220613113142.4338-3-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PDS_OTHER_BAD_TLD,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 13 Jun 2022 12:31:42 +0100, Lu=C3=ADs Henriques wrote:

> CephFS doesn't have a maximum xattr size.  Instead, it imposes a maximum
> size for the full set of xattrs names+values, which by default is 64K.  A=
nd
> since it reports 4M as the blocksize (the default ceph object size),
> generic/486 will fail in ceph because the XATTR_SIZE_MAX value can't be u=
sed
> in attr_replace_test.
>=20
> The fix is to add a new argument to the test so that the max size can be
> passed in instead of trying to auto-probe a value for it.
>=20
> Signed-off-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
> ---
>  src/attr_replace_test.c | 30 ++++++++++++++++++++++++++----
>  tests/generic/486       | 11 ++++++++++-
>  2 files changed, 36 insertions(+), 5 deletions(-)
>=20
> diff --git a/src/attr_replace_test.c b/src/attr_replace_test.c
> index cca8dcf8ff60..1218e7264c8f 100644
> --- a/src/attr_replace_test.c
> +++ b/src/attr_replace_test.c
> @@ -20,19 +20,41 @@ exit(1); } while (0)
>  fprintf(stderr, __VA_ARGS__); exit (1); \
>  } while (0)
> =20
> +void usage(char *progname)
> +{
> +	fail("usage: %s [-m max_attr_size] <file>\n", progname);
> +}
> +
>  int main(int argc, char *argv[])
>  {
>  	int ret;
>  	int fd;
> +	int c;
>  	char *path;
>  	char *name =3D "user.world";
>  	char *value;
>  	struct stat sbuf;
>  	size_t size =3D sizeof(value);
> +	size_t maxsize =3D XATTR_SIZE_MAX;
> +
> +	while ((c =3D getopt(argc, argv, "m:")) !=3D -1) {
> +		char *endp;
> +
> +		switch (c) {
> +		case 'm':
> +			maxsize =3D strtoul(optarg, &endp, 0);
> +			if (*endp || (maxsize > XATTR_SIZE_MAX))
> +				fail("Invalid 'max_attr_size' value\n");
> +			break;
> +		default:
> +			usage(argv[0]);
> +		}
> +	}
> =20
> -	if (argc !=3D 2)
> -		fail("Usage: %s <file>\n", argv[0]);
> -	path =3D argv[1];
> +	if (optind =3D=3D argc - 1)
> +		path =3D argv[optind];
> +	else
> +		usage(argv[0]);
> =20
>  	fd =3D open(path, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR);
>  	if (fd < 0) die();
> @@ -46,7 +68,7 @@ int main(int argc, char *argv[])
>  	size =3D sbuf.st_blksize * 3 / 4;
>  	if (!size)
>  		fail("Invalid st_blksize(%ld)\n", sbuf.st_blksize);
> -	size =3D MIN(size, XATTR_SIZE_MAX);
> +	size =3D MIN(size, maxsize);
>  	value =3D malloc(size);
>  	if (!value)
>  		fail("Failed to allocate memory\n");
> diff --git a/tests/generic/486 b/tests/generic/486
> index 7de198f93a71..7dbfcb9835d9 100755
> --- a/tests/generic/486
> +++ b/tests/generic/486
> @@ -41,7 +41,16 @@ filter_attr_output() {
>  		sed -e 's/has a [0-9]* byte value/has a NNNN byte value/g'
>  }
> =20
> -$here/src/attr_replace_test $SCRATCH_MNT/hello
> +max_attr_size=3D65536
> +
> +# attr_replace_test can't easily auto-probe the attr size for ceph becau=
se:
> +# - ceph imposes a maximum value for the total xattr names+values, and
> +# - ceph reports the 'object size' in the block size, which is, by defau=
lt, much
> +#   larger than XATTR_SIZE_MAX (4M > 64k)
> +# Hence, we need to provide it with a maximum size.
> +[ "$FSTYP" =3D "ceph" ] && max_attr_size=3D65000
> +
> +$here/src/attr_replace_test -m $max_attr_size $SCRATCH_MNT/hello
>  $ATTR_PROG -l $SCRATCH_MNT/hello >>$seqres.full 2>&1
>  $ATTR_PROG -l $SCRATCH_MNT/hello | filter_attr_output

Looks okay as an alternative to going through a 73aa648c
("generic/020: move MAX_ATTRS and MAX_ATTRVAL_SIZE logic") revert.

Reviewed-by: David Disseldorp <ddiss@suse.de>
