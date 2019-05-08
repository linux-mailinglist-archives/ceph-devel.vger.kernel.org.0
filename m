Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB42D1826A
	for <lists+ceph-devel@lfdr.de>; Thu,  9 May 2019 00:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfEHWry (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 May 2019 18:47:54 -0400
Received: from hr2.samba.org ([144.76.82.148]:39794 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbfEHWry (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 8 May 2019 18:47:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42627210; h=Message-ID:Cc:To:From:Date;
        bh=6lXc/XwAQcUK+fsfYHfbs8Axnc+ZnpuBiaQx6twRN7A=; b=jaaRa0szWNfXkDBsKpSg7StcJF
        A5UViuSWcwGWjkS/WYmJsfbKxNWPXYpGqicyP6GEaDn4hH7gVxDQnHuzYuGDt60KigK8RgWH6zoVD
        dMaytmQeEkQXmQlwLdc99x3yHB4MZenXlGaeTJ/+BSuHg/b8Y9CuaU3du/8+8/evKTtk=;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1hOVLk-0000D9-Bw; Wed, 08 May 2019 22:47:45 +0000
Date:   Wed, 8 May 2019 15:47:40 -0700
From:   Jeremy Allison <jra@samba.org>
To:     David Disseldorp <ddiss@suse.de>
Cc:     Samba Technical <samba-technical@lists.samba.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        jra@samba.org
Subject: Re: [PATCH] Samba: CephFS Snapshots VFS module
Message-ID: <20190508224740.GA21367@jra4>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20190329184531.0c78e06b@echidna.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190329184531.0c78e06b@echidna.suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Mar 29, 2019 at 06:45:31PM +0100, David Disseldorp via samba-technical wrote:
> 
> The attached patchset adds a new ceph_snapshots Samba VFS module which
> handles snapshot enumeration and timewarp/@GMT token mapping.
> 
> Feedback appreciated.

Mostly looks good - a few comments inline below. Hope you don't think
I'm being too picky, push back if so. I really want this functionality, just
want to make sure I can maintain it going forward.

Cheers,

	Jeremy.

> From dc42eb120b930f9fc8a8f232422812b61eb6ca9c Mon Sep 17 00:00:00 2001
> From: David Disseldorp <ddiss@samba.org>
> Date: Tue, 26 Mar 2019 16:35:18 +0100
> Subject: [PATCH 3/4] vfs: add ceph_snapshots module
> 
> vfs_ceph_snapshots is a module for accessing CephFS snapshots as
> Previous Versions. The module is separate from vfs_ceph, so that it can
> also be used atop a CephFS kernel backed share with vfs_default.
> 
> Signed-off-by: David Disseldorp <ddiss@samba.org>
> ---
>  source3/modules/vfs_ceph_snapshots.c | 1746 ++++++++++++++++++++++++++++++++++
>  source3/modules/wscript_build        |    8 +
>  source3/wscript                      |    5 +
>  3 files changed, 1759 insertions(+)
>  create mode 100644 source3/modules/vfs_ceph_snapshots.c
> 
> diff --git a/source3/modules/vfs_ceph_snapshots.c b/source3/modules/vfs_ceph_snapshots.c
> new file mode 100644
> index 00000000000..6f4e3f12640
> --- /dev/null
> +++ b/source3/modules/vfs_ceph_snapshots.c
> @@ -0,0 +1,1746 @@
> +/*
> + * Module for accessing CephFS snapshots as Previous Versions. This module is
> + * separate to vfs_ceph, so that it can also be used atop a CephFS kernel backed
> + * share with vfs_default.
> + *
> + * Copyright (C) David Disseldorp 2019
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 3 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <dirent.h>
> +#include <libgen.h>
> +#include "includes.h"
> +#include "include/ntioctl.h"
> +#include "include/smb.h"
> +#include "system/filesys.h"
> +#include "smbd/smbd.h"
> +#include "lib/util/tevent_ntstatus.h"
> +
> +#undef DBGC_CLASS
> +#define DBGC_CLASS DBGC_VFS
> +
> +/*
> + * CephFS has a magic snapshots subdirectory in all parts of the directory tree.
> + * This module automatically makes all snapshots in this subdir visible to SMB
> + * clients (if permitted by corresponding access control).
> + */
> +#define CEPH_SNAP_SUBDIR_DEFAULT ".snap"
> +/*
> + * The ceph.snap.btime (virtual) extended attribute carries the snapshot
> + * creation time in $secs.$nsecs format. It was added as part of
> + * https://tracker.ceph.com/issues/38838. Running Samba atop old Ceph versions
> + * which don't provide this xattr will not be able to enumerate or access
> + * snapshots using this module. As an alternative, vfs_shadow_copy2 could be
> + * used instead, alongside special shadow:format snapshot directory names.
> + */
> +#define CEPH_SNAP_BTIME_XATTR "ceph.snap.btime"
> +
> +static int ceph_snap_get_btime(struct vfs_handle_struct *handle,
> +			       struct smb_filename *smb_fname,
> +			       time_t *_snap_secs)
> +{
> +	int ret;
> +	char snap_btime[33];
> +	char *s = NULL;
> +	char *endptr = NULL;
> +	struct timespec snap_timespec;
> +	int err;
> +
> +	ret = SMB_VFS_NEXT_GETXATTR(handle, smb_fname, CEPH_SNAP_BTIME_XATTR,
> +				    snap_btime, sizeof(snap_btime));
> +	if (ret < 0) {
> +		DBG_ERR("failed to get %s xattr: %s\n",
> +			CEPH_SNAP_BTIME_XATTR, strerror(errno));
> +		return -errno;
> +	}
> +
> +	if (ret == 0 || ret >= sizeof(snap_btime) - 1) {
> +		return -EINVAL;
> +	}
> +
> +	/* ensure zero termination */
> +	snap_btime[ret] = '\0';
> +
> +	/* format is sec.nsec */
> +	s = strchr(snap_btime, '.');
> +	if (s == NULL) {
> +		DBG_ERR("invalid %s xattr value: %s\n",
> +			CEPH_SNAP_BTIME_XATTR, snap_btime);
> +		return -EINVAL;
> +	}
> +
> +	/* First component is seconds, extract it */
> +	*s = '\0';
> +	snap_timespec.tv_sec = strtoull_err(snap_btime, &endptr, 10, &err);
> +	if (err != 0) {
> +		return -err;
> +	}
> +	if ((endptr == snap_btime) || (*endptr != '\0')) {
> +		DBG_ERR("couldn't process snap.tv_sec in %s\n", snap_btime);
> +		return -EINVAL;
> +	}
> +
> +	/* second component is nsecs */
> +	s++;
> +	snap_timespec.tv_nsec = strtoul_err(s, &endptr, 10, &err);
> +	if (err != 0) {
> +		return -err;
> +	}
> +	if ((endptr == s) || (*endptr != '\0')) {
> +		DBG_ERR("couldn't process snap.tv_nsec in %s\n", s);
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * >> 30 is a rough divide by ~10**9. No need to be exact, as @GMT
> +	 * tokens only offer 1-second resolution (while twrp is nsec).
> +	 */
> +	*_snap_secs = snap_timespec.tv_sec + (snap_timespec.tv_nsec >> 30);
> +
> +	return 0;
> +}
> +
> +/*
> + * XXX Ceph snapshots can be created with sub-second granularity, which means
> + * that multiple snapshots may be mapped to the same @GMT- label.
> + *
> + * @return 0 if label successfully filled or -errno on error.
> + */
> +static int ceph_snap_fill_label(struct vfs_handle_struct *handle,
> +				TALLOC_CTX *tmp_ctx,
> +				const char *parent_snapsdir,
> +				const char *subdir,
> +				char *this_label)

There is a typedef char SHADOW_COPY_LABEL[25] which
described 'this_label'. Can you use that instead of
char *, otherwise the

memset(this_label, 0, sizeof(SHADOW_COPY_LABEL));

below looks weird and potentially overflow'y
(I know it isn't, but using SHADOW_COPY_LABEL
makes that clear).

> +{
> +	struct smb_filename *smb_fname;
> +	time_t snap_secs;
> +	struct tm gmt_snap_time;
> +	struct tm *tm_ret;
> +	size_t str_sz;
> +	char snap_path[PATH_MAX + 1];
> +	struct timespec snap_timespec;
> +	int ret;
> +
> +	/* safety first... */
> +	memset(this_label, 0, sizeof(SHADOW_COPY_LABEL));
> +
> +	/*
> +	 * CephFS snapshot creation times are available via a special
> +	 * xattr - snapshot b/m/ctimes all match the snap source.
> +	 */
> +	ret = snprintf(snap_path, sizeof(snap_path), "%s/%s",
> +			parent_snapsdir, subdir);
> +	if (ret >= sizeof(snap_path)) {
> +		return -EINVAL;
> +	}
> +
> +	smb_fname = synthetic_smb_fname(tmp_ctx, snap_path,
> +					NULL, NULL, 0);
> +	if (smb_fname == NULL) {
> +		return -ENOMEM;
> +	}
> +
> +	ret = ceph_snap_get_btime(handle, smb_fname, &snap_secs);
> +	if (ret < 0) {
> +		return ret;
> +	}
> +
> +	tm_ret = gmtime_r(&snap_secs, &gmt_snap_time);
> +	if (tm_ret == NULL) {
> +		return -EINVAL;
> +	}
> +	str_sz = strftime(this_label, sizeof(SHADOW_COPY_LABEL),
> +			  "@GMT-%Y.%m.%d-%H.%M.%S", &gmt_snap_time);
> +	if (str_sz == 0) {
> +		DBG_ERR("failed to convert tm to @GMT token\n");
> +		return -EINVAL;
> +	}
> +
> +	DBG_DEBUG("mapped snapshot at %s to enum snaps label %s\n",
> +		  snap_path, this_label);
> +
> +	return 0;
> +}
> +
> +static int ceph_snap_enum_snapdir(struct vfs_handle_struct *handle,
> +				  struct smb_filename *snaps_dname,
> +				  bool labels,
> +				  struct shadow_copy_data *sc_data)
> +{
> +	NTSTATUS status;
> +	int ret;
> +	DIR *d = NULL;
> +	struct dirent *e = NULL;
> +	int slots;

slots should be unsigned, or a size_t.

> +
> +	status = smbd_check_access_rights(handle->conn,
> +					snaps_dname,
> +					false,
> +					SEC_DIR_LIST);
> +	if (!NT_STATUS_IS_OK(status)) {
> +		DEBUG(0,("user does not have list permission "
> +			"on snapdir %s\n",
> +			snaps_dname->base_name));
> +		ret = -map_errno_from_nt_status(status);
> +		goto err_out;
> +	}
> +
> +	DBG_DEBUG("enumerating shadow copy dir at %s\n",
> +		  snaps_dname->base_name);
> +
> +	/*
> +	 * CephFS stat(dir).size *normally* returns the number of child entries
> +	 * for a given dir, but it unfortunately that's not the case for the one
> +	 * place we need it (dir=.snap), so we need to dynamically determine it
> +	 * via readdir.
> +	 */
> +	d = SMB_VFS_NEXT_OPENDIR(handle, snaps_dname, NULL, 0);
> +	if (d == NULL) {
> +		ret = -errno;
> +		goto err_out;
> +	}
> +
> +	slots = 0;
> +	sc_data->num_volumes = 0;
> +	sc_data->labels = NULL;
> +
> +	for (e = SMB_VFS_NEXT_READDIR(handle, d, NULL);
> +	     e != NULL;
> +	     e = SMB_VFS_NEXT_READDIR(handle, d, NULL)) {
> +		char *this_label;
> +
> +		if (ISDOT(e->d_name) || ISDOTDOT(e->d_name)) {
> +			continue;
> +		}
> +		sc_data->num_volumes++;
> +		if (!labels) {
> +			continue;
> +		}
> +		if (sc_data->num_volumes > slots) {
> +			slots += 10;

Can you do an overflow check here ?

Yes I know it's not possible. I'm still paranoid :-).

> +			DBG_DEBUG("%d slots for enum_snaps response\n", slots);
> +			sc_data->labels = talloc_realloc(sc_data,
> +							  sc_data->labels,
> +							  SHADOW_COPY_LABEL,
> +							  slots);
> +			if (sc_data->labels == NULL) {
> +				ret = -ENOMEM;
> +				goto err_closedir;
> +			}

Should you zero-fill the 10 new slots here ? Not strictly needed
I think. Your call here.

> +		}
> +		DBG_DEBUG("filling shadow copy label for %s/%s\n",
> +			  snaps_dname->base_name, e->d_name);
> +		ret = ceph_snap_fill_label(handle, snaps_dname,
> +				snaps_dname->base_name, e->d_name,
> +				sc_data->labels[sc_data->num_volumes - 1]);
> +		if (ret < 0) {
> +			goto err_closedir;
> +		}
> +	}
> +
> +	ret = SMB_VFS_NEXT_CLOSEDIR(handle, d);
> +	if (ret != 0) {
> +		ret = -errno;
> +		goto err_out;
> +	}
> +
> +	DBG_DEBUG("%s shadow copy enumeration found %d labels \n",
> +		  snaps_dname->base_name, sc_data->num_volumes);
> +
> +	return 0;
> +
> +err_closedir:
> +	SMB_VFS_NEXT_CLOSEDIR(handle, d);
> +err_out:
> +	TALLOC_FREE(sc_data->labels);
> +	return ret;
> +}
> +
> +/*
> + * Prior reading: The Meaning of Path Names
> + *   https://wiki.samba.org/index.php/Writing_a_Samba_VFS_Module
> + *
> + * translate paths so that we can use the parent dir for .snap access:
> + *   myfile        -> parent=        trimmed=myfile
> + *   /a            -> parent=/       trimmed=a
> + *   dir/sub/file  -> parent=dir/sub trimmed=file
> + *   /dir/sub      -> parent=/dir/   trimmed=sub
> + */
> +static int ceph_snap_get_parent_path(const char *connectpath,
> +				     const char *path,
> +				     char *_parent_buf,
> +				     size_t buflen,
> +				     const char **_trimmed)
> +{
> +	const char *p;
> +	int len;

len should be size_t I think. Below, do the assert the p >= path
instead of len >= 0.

> +	int ret;
> +
> +	if (!strcmp(path, "/")) {
> +		DBG_ERR("can't go past root for %s .snap dir\n", path);
> +		return -EINVAL;
> +	}
> +
> +	p = strrchr_m(path, '/'); /* Find final '/', if any */
> +	if (p == NULL) {
> +		DBG_DEBUG("parent .snap dir for %s is cwd\n", path);
> +		ret = strlcpy(_parent_buf, "", buflen);
> +		if (ret >= buflen) {
> +			return -EINVAL;
> +		}
> +		if (_trimmed != NULL) {
> +			*_trimmed = path;
> +		}
> +		return 0;
> +	}
> +
> +	len = p - path;
> +	SMB_ASSERT(len >= 0);
> +
> +	ret = snprintf(_parent_buf, buflen, "%.*s", len, path);
> +	if (ret >= buflen) {
> +		return -EINVAL;
> +	}
> +
> +	/* for absolute paths, check that we're not going outside the share */
> +	if ((len > 0) && (_parent_buf[0] == '/')) {
> +		size_t clen = strlen(connectpath);
> +		DBG_DEBUG("checking absolute path %s lies within share at %s\n",
> +			  _parent_buf, connectpath);
> +		/* need to check for separator, to avoid /x/abcd vs /x/ab */
> +		if (strncmp(connectpath, _parent_buf, clen)
> +		 || (_parent_buf[clen] != '/') && (_parent_buf[clen] != '\0')) {
> +			DBG_ERR("%s parent path is outside of share at %s\n",
> +				_parent_buf, connectpath);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	if (_trimmed != NULL) {
> +		/*
> +		 * point to path component which was trimmed from _parent_buf
> +		 * excluding path separator.
> +		 */
> +		*_trimmed = p + 1;
> +	}
> +
> +	DBG_DEBUG("generated parent .snap path for %s as %s (trimmed \"%s\")\n",
> +		  path, _parent_buf, p + 1);
> +
> +	return 0;
> +}
> +
> +static int ceph_snap_get_shadow_copy_data(struct vfs_handle_struct *handle,
> +					struct files_struct *fsp,
> +					struct shadow_copy_data *sc_data,
> +					bool labels)
> +{
> +	int ret;
> +	TALLOC_CTX *tmp_ctx;
> +	const char *parent_dir = NULL;
> +	char tmp[PATH_MAX + 1];
> +	char snaps_path[PATH_MAX + 1];
> +	struct smb_filename *snaps_dname = NULL;
> +	const char *snapdir = lp_parm_const_string(SNUM(handle->conn),
> +						   "ceph", "snapdir",
> +						   CEPH_SNAP_SUBDIR_DEFAULT);
> +
> +	DBG_DEBUG("getting shadow copy data for %s\n",
> +		  fsp->fsp_name->base_name);
> +
> +	tmp_ctx = talloc_new(fsp);
> +	if (tmp_ctx == NULL) {
> +		ret = -ENOMEM;
> +		goto err_out;
> +	}
> +
> +	if (sc_data == NULL) {
> +		ret = -EINVAL;
> +		goto err_out;
> +	}
> +
> +	if (fsp->is_directory) {
> +		parent_dir = fsp->fsp_name->base_name;
> +	} else {
> +		ret = ceph_snap_get_parent_path(handle->conn->connectpath,
> +						fsp->fsp_name->base_name,
> +						tmp,
> +						sizeof(tmp),
> +						NULL);	/* trimmed */
> +		if (ret < 0) {
> +			goto err_out;
> +		}
> +		parent_dir = tmp;
> +	}
> +
> +	ret = snprintf(snaps_path, sizeof(snaps_path), "%s/%s",
> +		       parent_dir, snapdir);
> +	if (ret >= sizeof(snaps_path)) {
> +		ret = -EINVAL;
> +		goto err_out;
> +	}
> +
> +	snaps_dname = synthetic_smb_fname(tmp_ctx,
> +				snaps_path,
> +				NULL,
> +				NULL,
> +				fsp->fsp_name->flags);
> +	if (snaps_dname == NULL) {
> +		ret = -ENOMEM;
> +		goto err_out;
> +	}
> +
> +	ret = ceph_snap_enum_snapdir(handle, snaps_dname, labels, sc_data);
> +	if (ret < 0) {
> +		goto err_out;
> +	}
> +
> +	talloc_free(tmp_ctx);
> +	return 0;
> +
> +err_out:
> +	talloc_free(tmp_ctx);
> +	errno = -ret;
> +	return -1;
> +}
> +
> +static bool ceph_snap_gmt_strip_snapshot(struct vfs_handle_struct *handle,
> +					 const char *name,
> +					 time_t *_timestamp,
> +					 char *_stripped_buf,
> +					 size_t buflen)
> +{
> +	struct tm tm;
> +	time_t timestamp;
> +	const char *p;
> +	char *q;
> +	char *stripped;
> +	size_t rest_len, dst_len;
> +	ptrdiff_t len_before_gmt;
> +
> +	p = strstr_m(name, "@GMT-");
> +	if (p == NULL) {
> +		goto no_snapshot;
> +	}
> +	if ((p > name) && (p[-1] != '/')) {
> +		goto no_snapshot;
> +	}
> +	len_before_gmt = p - name;
> +	q = strptime(p, GMT_FORMAT, &tm);
> +	if (q == NULL) {
> +		goto no_snapshot;
> +	}
> +	tm.tm_isdst = -1;
> +	timestamp = timegm(&tm);
> +	if (timestamp == (time_t)-1) {
> +		goto no_snapshot;
> +	}
> +	if (q[0] == '\0') {
> +		/*
> +		 * The name consists of only the GMT token or the GMT
> +		 * token is at the end of the path.
> +		 */
> +		if (_stripped_buf != NULL) {
> +			if (len_before_gmt >= buflen) {
> +				return -EINVAL;
> +			}
> +			if (len_before_gmt > 0) {
> +				/*
> +				 * There is a slash before the @GMT-. Remove it
> +				 * and copy the result.
> +				 */
> +				len_before_gmt -= 1;
> +				strlcpy(_stripped_buf, name, len_before_gmt);
> +			} else {
> +				_stripped_buf[0] = '\0';	/* token only */
> +			}
> +			DBG_DEBUG("GMT token in %s stripped to %s\n",
> +				  name, _stripped_buf);
> +		}
> +		*_timestamp = timestamp;
> +		return 0;
> +	}
> +	if (q[0] != '/') {
> +		/*
> +		 * It is not a complete path component, i.e. the path
> +		 * component continues after the gmt-token.
> +		 */
> +		goto no_snapshot;
> +	}
> +	q += 1;
> +
> +	rest_len = strlen(q);
> +	dst_len = len_before_gmt + rest_len;
> +	SMB_ASSERT(dst_len >= rest_len);
> +
> +	if (_stripped_buf != NULL) {
> +		if (dst_len >= buflen) {
> +			return -EINVAL;
> +		}
> +		if (p > name) {
> +			memcpy(_stripped_buf, name, len_before_gmt);
> +		}
> +		if (rest_len > 0) {
> +			memcpy(_stripped_buf + len_before_gmt, q, rest_len);
> +		}
> +		_stripped_buf[dst_len] = '\0';
> +	}
> +	*_timestamp = timestamp;
> +	DBG_DEBUG("GMT token in %s stripped to %s\n", name, _stripped_buf);
> +	return 0;
> +no_snapshot:
> +	*_timestamp = 0;
> +	return 0;
> +}
> +
> +static int ceph_snap_gmt_convert_dir(struct vfs_handle_struct *handle,
> +				     const char *name,
> +				     time_t timestamp,
> +				     char *_converted_buf,
> +				     size_t buflen)
> +{
> +	int ret;
> +	NTSTATUS status;
> +	DIR *d = NULL;
> +	struct dirent *e = NULL;
> +	struct smb_filename *snaps_dname = NULL;
> +	const char *snapdir = lp_parm_const_string(SNUM(handle->conn),
> +						   "ceph", "snapdir",
> +						   CEPH_SNAP_SUBDIR_DEFAULT);
> +	TALLOC_CTX *tmp_ctx = talloc_new(NULL);
> +
> +	if (tmp_ctx == NULL) {
> +		ret = -ENOMEM;
> +		goto err_out;
> +	}
> +
> +	/*
> +	 * Temporally use the caller's return buffer for this.
> +	 */
> +	ret = snprintf(_converted_buf, buflen, "%s/%s", name, snapdir);
> +	if (ret >= buflen) {
> +		ret = -EINVAL;
> +		goto err_out;
> +	}
> +
> +	snaps_dname = synthetic_smb_fname(tmp_ctx,
> +				_converted_buf,
> +				NULL,
> +				NULL,
> +				0);	/* XXX check? */
> +	if (snaps_dname == NULL) {
> +		ret = -ENOMEM;
> +		goto err_out;
> +	}
> +
> +	/* stat first to trigger error fallback in ceph_snap_gmt_convert() */
> +	ret = SMB_VFS_NEXT_STAT(handle, snaps_dname);
> +	if (ret < 0) {
> +		ret = -errno;
> +		goto err_out;
> +	}
> +
> +	status = smbd_check_access_rights(handle->conn,
> +					snaps_dname,
> +					false,
> +					SEC_DIR_LIST);
> +	if (!NT_STATUS_IS_OK(status)) {
> +		DEBUG(0,("user does not have list permission "
> +			"on snapdir %s\n",
> +			snaps_dname->base_name));
> +		ret = -map_errno_from_nt_status(status);
> +		goto err_out;
> +	}
> +
> +	DBG_DEBUG("enumerating shadow copy dir at %s\n",
> +		  snaps_dname->base_name);
> +
> +	d = SMB_VFS_NEXT_OPENDIR(handle, snaps_dname, NULL, 0);
> +	if (d == NULL) {
> +		ret = -errno;
> +		goto err_out;
> +	}
> +
> +	for (e = SMB_VFS_NEXT_READDIR(handle, d, NULL);
> +	     e != NULL;
> +	     e = SMB_VFS_NEXT_READDIR(handle, d, NULL)) {
> +		struct smb_filename *smb_fname;
> +		time_t snap_secs;
> +
> +		if (ISDOT(e->d_name) || ISDOTDOT(e->d_name)) {
> +			continue;
> +		}
> +
> +		ret = snprintf(_converted_buf, buflen, "%s/%s",
> +			       snaps_dname->base_name, e->d_name);
> +		if (ret >= buflen) {
> +			ret = -EINVAL;
> +			goto err_closedir;
> +		}
> +
> +		smb_fname = synthetic_smb_fname(tmp_ctx, _converted_buf,
> +						NULL, NULL, 0);
> +		if (smb_fname == NULL) {
> +			ret = -ENOMEM;
> +			goto err_closedir;
> +		}
> +
> +		ret = ceph_snap_get_btime(handle, smb_fname, &snap_secs);
> +		if (ret < 0) {
> +			goto err_closedir;
> +		}
> +
> +		/*
> +		 * check gmt_snap_time matches @timestamp
> +		 */
> +		if (timestamp == snap_secs) {
> +			break;
> +		}
> +		DBG_DEBUG("[connectpath %s] %s@%d no match for snap %s@%d\n",
> +			  handle->conn->connectpath, name, timestamp,
> +			  e->d_name, snap_secs);
> +	}
> +
> +	if (e == NULL) {
> +		DBG_INFO("[connectpath %s] failed to find %s @ time %d\n",
> +			 handle->conn->connectpath, name, timestamp);
> +		ret = -ENOENT;
> +		goto err_closedir;
> +	}
> +
> +	/* found, _converted_buf already contains path of interest */
> +	DBG_DEBUG("[connectpath %s] converted %s @ time %d to %s\n",
> +		  handle->conn->connectpath, name, timestamp, _converted_buf);
> +
> +	ret = SMB_VFS_NEXT_CLOSEDIR(handle, d);
> +	if (ret != 0) {
> +		ret = -errno;
> +		goto err_out;
> +	}
> +	talloc_free(tmp_ctx);
> +	return 0;
> +
> +err_closedir:
> +	SMB_VFS_NEXT_CLOSEDIR(handle, d);
> +err_out:
> +	talloc_free(tmp_ctx);
> +	return ret;
> +}
> +
> +static int ceph_snap_gmt_convert(struct vfs_handle_struct *handle,
> +				     const char *name,
> +				     time_t timestamp,
> +				     char *_converted_buf,
> +				     size_t buflen)
> +{
> +	int ret;
> +	char parent[PATH_MAX + 1];
> +	const char *trimmed = NULL;
> +	/*
> +	 * CephFS Snapshots for a given dir are nested under the ./.snap subdir
> +	 * *or* under ../.snap/dir (and subsequent parent dirs).
> +	 * Child dirs inherit snapshots created in parent dirs if the child
> +	 * exists at the time of snapshot creation.
> +	 *
> +	 * At this point we don't know whether @name refers to a file or dir, so
> +	 * first assume it's a dir (with a corresponding .snaps subdir)
> +	 */
> +	ret = ceph_snap_gmt_convert_dir(handle,
> +					name,
> +					timestamp,
> +					_converted_buf,
> +					buflen);
> +	if (ret >= 0) {
> +		/* all done: .snap subdir exists - @name is a dir */
> +		DBG_DEBUG("%s is a dir, accessing snaps via .snap\n", name);
> +		return ret;
> +	}
> +
> +	/* @name/.snap access failed, attempt snapshot access via parent */
> +	DBG_DEBUG("%s/.snap access failed, attempting parent access\n",
> +		  name);
> +
> +	ret = ceph_snap_get_parent_path(handle->conn->connectpath,
> +					name,
> +					parent,
> +					sizeof(parent),
> +					&trimmed);
> +	if (ret < 0) {
> +		return ret;
> +	}
> +
> +	ret = ceph_snap_gmt_convert_dir(handle,
> +					parent,
> +					timestamp,
> +					_converted_buf,
> +					buflen);
> +	if (ret < 0) {
> +		return ret;
> +	}
> +
> +	/*
> +	 * found snapshot via parent. Append the child path component
> +	 * that was trimmed... +1 for path separator.
> +	 */
> +	if (strlen(_converted_buf) + 1 + strlen(trimmed) >= buflen) {
> +		return -EINVAL;
> +	}
> +	strncat(_converted_buf, "/", buflen);
> +	strncat(_converted_buf, trimmed, buflen);
> +
> +	return 0;
> +}
> +
> +static DIR *ceph_snap_gmt_opendir(vfs_handle_struct *handle,
> +				const struct smb_filename *csmb_fname,
> +				const char *mask,
> +				uint32_t attr)
> +{
> +	time_t timestamp = 0;
> +	char stripped[PATH_MAX + 1];
> +	int ret;
> +	DIR *dir;
> +	int saved_errno;
> +	struct smb_filename *conv_smb_fname = NULL;
> +	char conv[PATH_MAX + 1];
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +			csmb_fname->base_name,
> +			&timestamp,
> +			stripped, sizeof(stripped));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return NULL;
> +	}
> +	if (timestamp == 0) {
> +		return SMB_VFS_NEXT_OPENDIR(handle, csmb_fname, mask, attr);
> +	}
> +	ret = ceph_snap_gmt_convert_dir(handle, stripped,
> +					timestamp, conv, sizeof(conv));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return NULL;
> +	}
> +	conv_smb_fname = synthetic_smb_fname(talloc_tos(),
> +					conv,
> +					NULL,
> +					NULL,
> +					csmb_fname->flags);
> +	if (conv_smb_fname == NULL) {
> +		errno = ENOMEM;
> +		return NULL;
> +	}
> +
> +	dir = SMB_VFS_NEXT_OPENDIR(handle, conv_smb_fname, mask, attr);
> +	saved_errno = errno;
> +	TALLOC_FREE(conv_smb_fname);
> +	errno = saved_errno;
> +	return dir;
> +}
> +
> +static int ceph_snap_gmt_rename(vfs_handle_struct *handle,
> +			      const struct smb_filename *smb_fname_src,
> +			      const struct smb_filename *smb_fname_dst)
> +{
> +	int ret;
> +	time_t timestamp_src, timestamp_dst;
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +					smb_fname_src->base_name,
> +					&timestamp_src, NULL, 0);
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +					smb_fname_dst->base_name,
> +					&timestamp_dst, NULL, 0);
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	if (timestamp_src != 0) {
> +		errno = EXDEV;
> +		return -1;
> +	}
> +	if (timestamp_dst != 0) {
> +		errno = EROFS;
> +		return -1;
> +	}
> +	return SMB_VFS_NEXT_RENAME(handle, smb_fname_src, smb_fname_dst);
> +}
> +
> +/* block links from writeable shares to snapshots for now, like other modules */
> +static int ceph_snap_gmt_symlink(vfs_handle_struct *handle,
> +				const char *link_contents,
> +				const struct smb_filename *new_smb_fname)
> +{
> +	int ret;
> +	time_t timestamp_old = 0;
> +	time_t timestamp_new = 0;
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +				link_contents,
> +				&timestamp_old,
> +				NULL, 0);
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +				new_smb_fname->base_name,
> +				&timestamp_new,
> +				NULL, 0);
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	if ((timestamp_old != 0) || (timestamp_new != 0)) {
> +		errno = EROFS;
> +		return -1;
> +	}
> +	return SMB_VFS_NEXT_SYMLINK(handle, link_contents, new_smb_fname);
> +}
> +
> +static int ceph_snap_gmt_link(vfs_handle_struct *handle,
> +				const struct smb_filename *old_smb_fname,
> +				const struct smb_filename *new_smb_fname)
> +{
> +	int ret;
> +	time_t timestamp_old = 0;
> +	time_t timestamp_new = 0;
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +				old_smb_fname->base_name,
> +				&timestamp_old,
> +				NULL, 0);
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +				new_smb_fname->base_name,
> +				&timestamp_new,
> +				NULL, 0);
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	if ((timestamp_old != 0) || (timestamp_new != 0)) {
> +		errno = EROFS;
> +		return -1;
> +	}
> +	return SMB_VFS_NEXT_LINK(handle, old_smb_fname, new_smb_fname);
> +}
> +
> +static int ceph_snap_gmt_stat(vfs_handle_struct *handle,
> +			    struct smb_filename *smb_fname)
> +{
> +	time_t timestamp = 0;
> +	char stripped[PATH_MAX + 1];
> +	char conv[PATH_MAX + 1];
> +	char *tmp;
> +	int ret;
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +					smb_fname->base_name,
> +					&timestamp, stripped, sizeof(stripped));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	if (timestamp == 0) {
> +		return SMB_VFS_NEXT_STAT(handle, smb_fname);
> +	}
> +
> +	ret = ceph_snap_gmt_convert(handle, stripped,
> +					timestamp, conv, sizeof(conv));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	tmp = smb_fname->base_name;
> +	smb_fname->base_name = conv;
> +
> +	ret = SMB_VFS_NEXT_STAT(handle, smb_fname);
> +	smb_fname->base_name = tmp;
> +	return ret;
> +}
> +
> +static int ceph_snap_gmt_lstat(vfs_handle_struct *handle,
> +			     struct smb_filename *smb_fname)
> +{
> +	time_t timestamp = 0;
> +	char stripped[PATH_MAX + 1];
> +	char conv[PATH_MAX + 1];
> +	char *tmp;
> +	int ret;
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +					smb_fname->base_name,
> +					&timestamp, stripped, sizeof(stripped));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	if (timestamp == 0) {
> +		return SMB_VFS_NEXT_LSTAT(handle, smb_fname);
> +	}
> +
> +	ret = ceph_snap_gmt_convert(handle, stripped,
> +					timestamp, conv, sizeof(conv));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	tmp = smb_fname->base_name;
> +	smb_fname->base_name = conv;
> +
> +	ret = SMB_VFS_NEXT_LSTAT(handle, smb_fname);
> +	smb_fname->base_name = tmp;
> +	return ret;
> +}
> +
> +static int ceph_snap_gmt_open(vfs_handle_struct *handle,
> +			    struct smb_filename *smb_fname, files_struct *fsp,
> +			    int flags, mode_t mode)
> +{
> +	time_t timestamp = 0;
> +	char stripped[PATH_MAX + 1];
> +	char conv[PATH_MAX + 1];
> +	char *tmp;
> +	int ret;
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +					smb_fname->base_name,
> +					&timestamp, stripped, sizeof(stripped));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	if (timestamp == 0) {
> +		return SMB_VFS_NEXT_OPEN(handle, smb_fname, fsp, flags, mode);
> +	}
> +
> +	ret = ceph_snap_gmt_convert(handle, stripped,
> +					timestamp, conv, sizeof(conv));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	tmp = smb_fname->base_name;
> +	smb_fname->base_name = conv;
> +
> +	ret = SMB_VFS_NEXT_OPEN(handle, smb_fname, fsp, flags, mode);
> +	smb_fname->base_name = tmp;
> +	return ret;
> +}
> +
> +/*
> + * XXX play discard_const() games with const smb_filename structs, to avoid
> + * allocation of a new struct just for this.
> + */

Can you do an allocation instead ? I really hate discard_const_p()
tricks, eventually they bite :-). Isn't it possible a real const char
is getting passed inside these smb_filenames ?

I don't think these are performance critical code paths.

Can't you change ceph_snap_gmt_strip_snapshot() to return
a talloc'ed struct smb_filename from a passed in const one ?

Pass in a talloc context of talloc_tos() and remember to free
in exit paths. That's what it's for (sorry I know you hate it,
but it's appropriate here IMHO of course).

> +static int ceph_snap_gmt_unlink(vfs_handle_struct *handle,
> +			      const struct smb_filename *csmb_fname)
> +{
> +	time_t timestamp = 0;
> +	char stripped[PATH_MAX + 1];
> +	char conv[PATH_MAX + 1];
> +	char *tmp;
> +	int ret;
> +	struct smb_filename *smb_fname = discard_const_p(struct smb_filename,
> +							 csmb_fname);
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +					smb_fname->base_name,
> +					&timestamp, stripped, sizeof(stripped));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	if (timestamp == 0) {
> +		return SMB_VFS_NEXT_UNLINK(handle, smb_fname);
> +	}
> +
> +	ret = ceph_snap_gmt_convert(handle, stripped,
> +					timestamp, conv, sizeof(conv));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	tmp = smb_fname->base_name;
> +	smb_fname->base_name = conv;
> +
> +	ret = SMB_VFS_NEXT_UNLINK(handle, smb_fname);
> +	smb_fname->base_name = tmp;
> +	return ret;
> +}
> +
> +static int ceph_snap_gmt_chmod(vfs_handle_struct *handle,
> +			const struct smb_filename *csmb_fname,
> +			mode_t mode)
> +{
> +	time_t timestamp = 0;
> +	char stripped[PATH_MAX + 1];
> +	char conv[PATH_MAX + 1];
> +	char *tmp;
> +	int ret;
> +	struct smb_filename *smb_fname = discard_const_p(struct smb_filename,
> +							 csmb_fname);
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +					smb_fname->base_name,
> +					&timestamp, stripped, sizeof(stripped));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	if (timestamp == 0) {
> +		return SMB_VFS_NEXT_CHMOD(handle, smb_fname, mode);
> +	}
> +
> +	ret = ceph_snap_gmt_convert(handle, stripped,
> +					timestamp, conv, sizeof(conv));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	tmp = smb_fname->base_name;
> +	smb_fname->base_name = conv;
> +
> +	ret = SMB_VFS_NEXT_CHMOD(handle, smb_fname, mode);
> +	smb_fname->base_name = tmp;
> +	return ret;
> +}
> +
> +static int ceph_snap_gmt_chown(vfs_handle_struct *handle,
> +			const struct smb_filename *csmb_fname,
> +			uid_t uid,
> +			gid_t gid)
> +{
> +	time_t timestamp = 0;
> +	char stripped[PATH_MAX + 1];
> +	char conv[PATH_MAX + 1];
> +	char *tmp;
> +	int ret;
> +	struct smb_filename *smb_fname = discard_const_p(struct smb_filename,
> +							 csmb_fname);
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +					smb_fname->base_name,
> +					&timestamp, stripped, sizeof(stripped));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	if (timestamp == 0) {
> +		return SMB_VFS_NEXT_CHOWN(handle, smb_fname, uid, gid);
> +	}
> +
> +	ret = ceph_snap_gmt_convert(handle, stripped,
> +					timestamp, conv, sizeof(conv));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	tmp = smb_fname->base_name;
> +	smb_fname->base_name = conv;
> +
> +	ret = SMB_VFS_NEXT_CHOWN(handle, smb_fname, uid, gid);
> +	smb_fname->base_name = tmp;
> +	return ret;
> +}
> +
> +static int ceph_snap_gmt_chdir(vfs_handle_struct *handle,
> +			const struct smb_filename *csmb_fname)
> +{
> +	time_t timestamp = 0;
> +	char stripped[PATH_MAX + 1];
> +	char conv[PATH_MAX + 1];
> +	char *tmp;
> +	int ret;
> +	struct smb_filename *smb_fname = discard_const_p(struct smb_filename,
> +							 csmb_fname);
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +					smb_fname->base_name,
> +					&timestamp, stripped, sizeof(stripped));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	if (timestamp == 0) {
> +		return SMB_VFS_NEXT_CHDIR(handle, smb_fname);
> +	}
> +
> +	ret = ceph_snap_gmt_convert_dir(handle, stripped,
> +					timestamp, conv, sizeof(conv));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	tmp = smb_fname->base_name;
> +	smb_fname->base_name = conv;
> +
> +	ret = SMB_VFS_NEXT_CHDIR(handle, smb_fname);
> +	smb_fname->base_name = tmp;
> +	return ret;
> +}
> +
> +static int ceph_snap_gmt_ntimes(vfs_handle_struct *handle,
> +			      const struct smb_filename *csmb_fname,
> +			      struct smb_file_time *ft)
> +{
> +	time_t timestamp = 0;
> +	char stripped[PATH_MAX + 1];
> +	char conv[PATH_MAX + 1];
> +	char *tmp;
> +	int ret;
> +	struct smb_filename *smb_fname = discard_const_p(struct smb_filename,
> +							 csmb_fname);
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +					smb_fname->base_name,
> +					&timestamp, stripped, sizeof(stripped));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	if (timestamp == 0) {
> +		return SMB_VFS_NEXT_NTIMES(handle, smb_fname, ft);
> +	}
> +
> +	ret = ceph_snap_gmt_convert(handle, stripped,
> +					timestamp, conv, sizeof(conv));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	tmp = smb_fname->base_name;
> +	smb_fname->base_name = conv;
> +
> +	ret = SMB_VFS_NEXT_NTIMES(handle, smb_fname, ft);
> +	smb_fname->base_name = tmp;
> +	return ret;
> +}
> +
> +static int ceph_snap_gmt_readlink(vfs_handle_struct *handle,
> +				const struct smb_filename *csmb_fname,
> +				char *buf,
> +				size_t bufsiz)
> +{
> +	time_t timestamp = 0;
> +	char stripped[PATH_MAX + 1];
> +	char conv[PATH_MAX + 1];
> +	char *tmp;
> +	int ret;
> +	struct smb_filename *smb_fname = discard_const_p(struct smb_filename,
> +							 csmb_fname);
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +					smb_fname->base_name,
> +					&timestamp, stripped, sizeof(stripped));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	if (timestamp == 0) {
> +		return SMB_VFS_NEXT_READLINK(handle, smb_fname, buf, bufsiz);
> +	}
> +	ret = ceph_snap_gmt_convert(handle, stripped,
> +					timestamp, conv, sizeof(conv));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	tmp = smb_fname->base_name;
> +	smb_fname->base_name = conv;
> +
> +	ret = SMB_VFS_NEXT_READLINK(handle, smb_fname, buf, bufsiz);
> +	smb_fname->base_name = tmp;
> +	return ret;
> +}
> +
> +static int ceph_snap_gmt_mknod(vfs_handle_struct *handle,
> +			const struct smb_filename *csmb_fname,
> +			mode_t mode,
> +			SMB_DEV_T dev)
> +{
> +	time_t timestamp = 0;
> +	char stripped[PATH_MAX + 1];
> +	char conv[PATH_MAX + 1];
> +	char *tmp;
> +	int ret;
> +	struct smb_filename *smb_fname = discard_const_p(struct smb_filename,
> +							 csmb_fname);
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +					smb_fname->base_name,
> +					&timestamp, stripped, sizeof(stripped));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	if (timestamp == 0) {
> +		return SMB_VFS_NEXT_MKNOD(handle, smb_fname, mode, dev);
> +	}
> +	ret = ceph_snap_gmt_convert(handle, stripped,
> +					timestamp, conv, sizeof(conv));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	tmp = smb_fname->base_name;
> +	smb_fname->base_name = conv;
> +
> +	ret = SMB_VFS_NEXT_MKNOD(handle, smb_fname, mode, dev);
> +	smb_fname->base_name = tmp;
> +	return ret;
> +}
> +
> +static struct smb_filename *ceph_snap_gmt_realpath(vfs_handle_struct *handle,
> +				TALLOC_CTX *ctx,
> +				const struct smb_filename *csmb_fname)
> +{
> +	time_t timestamp = 0;
> +	char stripped[PATH_MAX + 1];
> +	char conv[PATH_MAX + 1];
> +	char *tmp;
> +	struct smb_filename *result_fname;
> +	int ret;
> +	struct smb_filename *smb_fname = discard_const_p(struct smb_filename,
> +							 csmb_fname);
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +					smb_fname->base_name,
> +					&timestamp, stripped, sizeof(stripped));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return NULL;
> +	}
> +	if (timestamp == 0) {
> +		return SMB_VFS_NEXT_REALPATH(handle, ctx, smb_fname);
> +	}
> +	ret = ceph_snap_gmt_convert(handle, stripped,
> +					timestamp, conv, sizeof(conv));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return NULL;
> +	}
> +	tmp = smb_fname->base_name;
> +	smb_fname->base_name = conv;
> +
> +	result_fname = SMB_VFS_NEXT_REALPATH(handle, ctx, smb_fname);
> +	smb_fname->base_name = tmp;
> +	return result_fname;
> +}
> +
> +/*
> + * XXX this should have gone through open() conversion, so why do we need
> + * a handler here? posix_fget_nt_acl() falls back to posix_get_nt_acl() for
> + * dirs (or fd == -1).
> + */
> +static NTSTATUS ceph_snap_gmt_fget_nt_acl(vfs_handle_struct *handle,
> +					struct files_struct *fsp,
> +					uint32_t security_info,
> +					TALLOC_CTX *mem_ctx,
> +					struct security_descriptor **ppdesc)
> +{
> +	time_t timestamp = 0;
> +	char stripped[PATH_MAX + 1];
> +	char conv[PATH_MAX + 1];
> +	char *tmp;
> +	struct smb_filename *smb_fname;
> +	int ret;
> +	NTSTATUS status;
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +					fsp->fsp_name->base_name,
> +					&timestamp, stripped, sizeof(stripped));
> +	if (ret < 0) {
> +		return map_nt_error_from_unix(-ret);
> +	}
> +	if (timestamp == 0) {
> +		return SMB_VFS_NEXT_FGET_NT_ACL(handle, fsp, security_info,
> +						mem_ctx,
> +						ppdesc);
> +	}
> +	ret = ceph_snap_gmt_convert(handle, stripped,
> +					timestamp, conv, sizeof(conv));
> +	if (ret < 0) {
> +		return map_nt_error_from_unix(-ret);
> +	}
> +
> +	smb_fname = synthetic_smb_fname(mem_ctx,
> +					conv,
> +					NULL,
> +					NULL,
> +					fsp->fsp_name->flags);
> +	if (smb_fname == NULL) {
> +		return NT_STATUS_NO_MEMORY;
> +	}
> +
> +	status = SMB_VFS_NEXT_GET_NT_ACL(handle, smb_fname, security_info,
> +					 mem_ctx, ppdesc);
> +	TALLOC_FREE(smb_fname);
> +	return status;
> +}
> +
> +static NTSTATUS ceph_snap_gmt_get_nt_acl(vfs_handle_struct *handle,
> +				       const struct smb_filename *csmb_fname,
> +				       uint32_t security_info,
> +				       TALLOC_CTX *mem_ctx,
> +				       struct security_descriptor **ppdesc)
> +{
> +	time_t timestamp = 0;
> +	char stripped[PATH_MAX + 1];
> +	char conv[PATH_MAX + 1];
> +	char *tmp;
> +	int ret;
> +	NTSTATUS status;
> +	struct smb_filename *smb_fname = discard_const_p(struct smb_filename,
> +							 csmb_fname);
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +					smb_fname->base_name,
> +					&timestamp, stripped, sizeof(stripped));
> +	if (ret < 0) {
> +		return map_nt_error_from_unix(-ret);
> +	}
> +	if (timestamp == 0) {
> +		return SMB_VFS_NEXT_GET_NT_ACL(handle, smb_fname, security_info,
> +					       mem_ctx, ppdesc);
> +	}
> +	ret = ceph_snap_gmt_convert(handle, stripped,
> +					timestamp, conv, sizeof(conv));
> +	if (ret < 0) {
> +		return map_nt_error_from_unix(-ret);
> +	}
> +	tmp = smb_fname->base_name;
> +	smb_fname->base_name = conv;
> +
> +	status = SMB_VFS_NEXT_GET_NT_ACL(handle, smb_fname, security_info,
> +					 mem_ctx, ppdesc);
> +	smb_fname->base_name = tmp;
> +	return status;
> +}
> +
> +static int ceph_snap_gmt_mkdir(vfs_handle_struct *handle,
> +				const struct smb_filename *csmb_fname,
> +				mode_t mode)
> +{
> +	time_t timestamp = 0;
> +	char stripped[PATH_MAX + 1];
> +	char conv[PATH_MAX + 1];
> +	char *tmp;
> +	int ret;
> +	struct smb_filename *smb_fname = discard_const_p(struct smb_filename,
> +							 csmb_fname);
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +					smb_fname->base_name,
> +					&timestamp, stripped, sizeof(stripped));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	if (timestamp == 0) {
> +		return SMB_VFS_NEXT_MKDIR(handle, smb_fname, mode);
> +	}
> +	ret = ceph_snap_gmt_convert_dir(handle, stripped,
> +					timestamp, conv, sizeof(conv));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	tmp = smb_fname->base_name;
> +	smb_fname->base_name = conv;
> +
> +	ret = SMB_VFS_NEXT_MKDIR(handle, smb_fname, mode);
> +	smb_fname->base_name = tmp;
> +	return ret;
> +}
> +
> +static int ceph_snap_gmt_rmdir(vfs_handle_struct *handle,
> +				const struct smb_filename *csmb_fname)
> +{
> +	time_t timestamp = 0;
> +	char stripped[PATH_MAX + 1];
> +	char conv[PATH_MAX + 1];
> +	char *tmp;
> +	int ret;
> +	struct smb_filename *smb_fname = discard_const_p(struct smb_filename,
> +							 csmb_fname);
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +					smb_fname->base_name,
> +					&timestamp, stripped, sizeof(stripped));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	if (timestamp == 0) {
> +		return SMB_VFS_NEXT_RMDIR(handle, smb_fname);
> +	}
> +	ret = ceph_snap_gmt_convert_dir(handle, stripped,
> +					timestamp, conv, sizeof(conv));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	tmp = smb_fname->base_name;
> +	smb_fname->base_name = conv;
> +
> +	ret = SMB_VFS_NEXT_RMDIR(handle, smb_fname);
> +	smb_fname->base_name = tmp;
> +	return ret;
> +}
> +
> +static int ceph_snap_gmt_chflags(vfs_handle_struct *handle,
> +				const struct smb_filename *csmb_fname,
> +				unsigned int flags)
> +{
> +	time_t timestamp = 0;
> +	char stripped[PATH_MAX + 1];
> +	char conv[PATH_MAX + 1];
> +	char *tmp;
> +	int ret;
> +	struct smb_filename *smb_fname = discard_const_p(struct smb_filename,
> +							 csmb_fname);
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +					smb_fname->base_name,
> +					&timestamp, stripped, sizeof(stripped));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	if (timestamp == 0) {
> +		return SMB_VFS_NEXT_CHFLAGS(handle, smb_fname, flags);
> +	}
> +	ret = ceph_snap_gmt_convert(handle, stripped,
> +					timestamp, conv, sizeof(conv));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	tmp = smb_fname->base_name;
> +	smb_fname->base_name = conv;
> +
> +	ret = SMB_VFS_NEXT_CHFLAGS(handle, smb_fname, flags);
> +	smb_fname->base_name = tmp;
> +	return ret;
> +}
> +
> +static ssize_t ceph_snap_gmt_getxattr(vfs_handle_struct *handle,
> +				const struct smb_filename *csmb_fname,
> +				const char *aname,
> +				void *value,
> +				size_t size)
> +{
> +	time_t timestamp = 0;
> +	char stripped[PATH_MAX + 1];
> +	char conv[PATH_MAX + 1];
> +	char *tmp;
> +	int ret;
> +	struct smb_filename *smb_fname = discard_const_p(struct smb_filename,
> +							 csmb_fname);
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +					smb_fname->base_name,
> +					&timestamp, stripped, sizeof(stripped));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	if (timestamp == 0) {
> +		return SMB_VFS_NEXT_GETXATTR(handle, smb_fname, aname, value,
> +					     size);
> +	}
> +	ret = ceph_snap_gmt_convert(handle, stripped,
> +					timestamp, conv, sizeof(conv));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	tmp = smb_fname->base_name;
> +	smb_fname->base_name = conv;
> +
> +	ret = SMB_VFS_NEXT_GETXATTR(handle, smb_fname, aname, value, size);
> +	smb_fname->base_name = tmp;
> +	return ret;
> +}
> +
> +static ssize_t ceph_snap_gmt_listxattr(struct vfs_handle_struct *handle,
> +				     const struct smb_filename *csmb_fname,
> +				     char *list, size_t size)
> +{
> +	time_t timestamp = 0;
> +	char stripped[PATH_MAX + 1];
> +	char conv[PATH_MAX + 1];
> +	char *tmp;
> +	int ret;
> +	struct smb_filename *smb_fname = discard_const_p(struct smb_filename,
> +							 csmb_fname);
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +					smb_fname->base_name,
> +					&timestamp, stripped, sizeof(stripped));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	if (timestamp == 0) {
> +		return SMB_VFS_NEXT_LISTXATTR(handle, smb_fname, list, size);
> +	}
> +	ret = ceph_snap_gmt_convert(handle, stripped,
> +					timestamp, conv, sizeof(conv));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	tmp = smb_fname->base_name;
> +	smb_fname->base_name = conv;
> +
> +	ret = SMB_VFS_NEXT_LISTXATTR(handle, smb_fname, list, size);
> +	smb_fname->base_name = tmp;
> +	return ret;
> +}
> +
> +static int ceph_snap_gmt_removexattr(vfs_handle_struct *handle,
> +				const struct smb_filename *csmb_fname,
> +				const char *aname)
> +{
> +	time_t timestamp = 0;
> +	char stripped[PATH_MAX + 1];
> +	char conv[PATH_MAX + 1];
> +	char *tmp;
> +	int ret;
> +	struct smb_filename *smb_fname = discard_const_p(struct smb_filename,
> +							 csmb_fname);
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +					smb_fname->base_name,
> +					&timestamp, stripped, sizeof(stripped));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	if (timestamp == 0) {
> +		return SMB_VFS_NEXT_REMOVEXATTR(handle, smb_fname, aname);
> +	}
> +	ret = ceph_snap_gmt_convert(handle, stripped,
> +					timestamp, conv, sizeof(conv));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	tmp = smb_fname->base_name;
> +	smb_fname->base_name = conv;
> +
> +	ret = SMB_VFS_NEXT_REMOVEXATTR(handle, smb_fname, aname);
> +	smb_fname->base_name = tmp;
> +	return ret;
> +}
> +
> +static int ceph_snap_gmt_setxattr(struct vfs_handle_struct *handle,
> +				const struct smb_filename *csmb_fname,
> +				const char *aname, const void *value,
> +				size_t size, int flags)
> +{
> +	time_t timestamp = 0;
> +	char stripped[PATH_MAX + 1];
> +	char conv[PATH_MAX + 1];
> +	char *tmp;
> +	int ret;
> +	struct smb_filename *smb_fname = discard_const_p(struct smb_filename,
> +							 csmb_fname);
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +					smb_fname->base_name,
> +					&timestamp, stripped, sizeof(stripped));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	if (timestamp == 0) {
> +		return SMB_VFS_NEXT_SETXATTR(handle, smb_fname,
> +					aname, value, size, flags);
> +	}
> +	ret = ceph_snap_gmt_convert(handle, stripped,
> +					timestamp, conv, sizeof(conv));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	tmp = smb_fname->base_name;
> +	smb_fname->base_name = conv;
> +
> +	ret = SMB_VFS_NEXT_SETXATTR(handle, smb_fname,
> +				aname, value, size, flags);
> +	smb_fname->base_name = tmp;
> +	return ret;
> +}
> +
> +static int ceph_snap_gmt_get_real_filename(struct vfs_handle_struct *handle,
> +					 const char *path,
> +					 const char *name,
> +					 TALLOC_CTX *mem_ctx,
> +					 char **found_name)
> +{
> +	time_t timestamp = 0;
> +	char stripped[PATH_MAX + 1];
> +	char conv[PATH_MAX + 1];
> +	int ret;
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle, path,
> +					&timestamp, stripped, sizeof(stripped));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	if (timestamp == 0) {
> +		return SMB_VFS_NEXT_GET_REAL_FILENAME(handle, path, name,
> +						      mem_ctx, found_name);
> +	}
> +	ret = ceph_snap_gmt_convert_dir(handle, stripped,
> +					timestamp, conv, sizeof(conv));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	ret = SMB_VFS_NEXT_GET_REAL_FILENAME(handle, conv, name,
> +					     mem_ctx, found_name);
> +	return ret;
> +}
> +
> +static uint64_t ceph_snap_gmt_disk_free(vfs_handle_struct *handle,
> +				const struct smb_filename *csmb_fname,
> +				uint64_t *bsize,
> +				uint64_t *dfree,
> +				uint64_t *dsize)
> +{
> +	time_t timestamp = 0;
> +	char stripped[PATH_MAX + 1];
> +	char conv[PATH_MAX + 1];
> +	char *tmp;
> +	int ret;
> +	struct smb_filename *smb_fname = discard_const_p(struct smb_filename,
> +							 csmb_fname);
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +					smb_fname->base_name,
> +					&timestamp, stripped, sizeof(stripped));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	if (timestamp == 0) {
> +		return SMB_VFS_NEXT_DISK_FREE(handle, smb_fname,
> +					      bsize, dfree, dsize);
> +	}
> +	ret = ceph_snap_gmt_convert(handle, stripped,
> +					timestamp, conv, sizeof(conv));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	tmp = smb_fname->base_name;
> +	smb_fname->base_name = conv;
> +
> +	ret = SMB_VFS_NEXT_DISK_FREE(handle, smb_fname,
> +				bsize, dfree, dsize);
> +	smb_fname->base_name = tmp;
> +	return ret;
> +}
> +
> +static int ceph_snap_gmt_get_quota(vfs_handle_struct *handle,
> +			const struct smb_filename *csmb_fname,
> +			enum SMB_QUOTA_TYPE qtype,
> +			unid_t id,
> +			SMB_DISK_QUOTA *dq)
> +{
> +	time_t timestamp = 0;
> +	char stripped[PATH_MAX + 1];
> +	char conv[PATH_MAX + 1];
> +	char *tmp;
> +	int ret;
> +	struct smb_filename *smb_fname = discard_const_p(struct smb_filename,
> +							 csmb_fname);
> +
> +	ret = ceph_snap_gmt_strip_snapshot(handle,
> +					smb_fname->base_name,
> +					&timestamp, stripped, sizeof(stripped));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	if (timestamp == 0) {
> +		return SMB_VFS_NEXT_GET_QUOTA(handle, smb_fname, qtype, id, dq);
> +	}
> +	ret = ceph_snap_gmt_convert(handle, stripped,
> +					timestamp, conv, sizeof(conv));
> +	if (ret < 0) {
> +		errno = -ret;
> +		return -1;
> +	}
> +	tmp = smb_fname->base_name;
> +	smb_fname->base_name = conv;
> +
> +	ret = SMB_VFS_NEXT_GET_QUOTA(handle, smb_fname, qtype, id, dq);
> +	smb_fname->base_name = tmp;
> +	return ret;
> +}
> +
> +static struct vfs_fn_pointers ceph_snap_fns = {
> +	.get_shadow_copy_data_fn = ceph_snap_get_shadow_copy_data,
> +	.opendir_fn = ceph_snap_gmt_opendir,
> +	.disk_free_fn = ceph_snap_gmt_disk_free,
> +	.get_quota_fn = ceph_snap_gmt_get_quota,
> +	.rename_fn = ceph_snap_gmt_rename,
> +	.link_fn = ceph_snap_gmt_link,
> +	.symlink_fn = ceph_snap_gmt_symlink,
> +	.stat_fn = ceph_snap_gmt_stat,
> +	.lstat_fn = ceph_snap_gmt_lstat,
> +	.open_fn = ceph_snap_gmt_open,
> +	.unlink_fn = ceph_snap_gmt_unlink,
> +	.chmod_fn = ceph_snap_gmt_chmod,
> +	.chown_fn = ceph_snap_gmt_chown,
> +	.chdir_fn = ceph_snap_gmt_chdir,
> +	.ntimes_fn = ceph_snap_gmt_ntimes,
> +	.readlink_fn = ceph_snap_gmt_readlink,
> +	.mknod_fn = ceph_snap_gmt_mknod,
> +	.realpath_fn = ceph_snap_gmt_realpath,
> +	.get_nt_acl_fn = ceph_snap_gmt_get_nt_acl,
> +	.fget_nt_acl_fn = ceph_snap_gmt_fget_nt_acl,
> +	.get_nt_acl_fn = ceph_snap_gmt_get_nt_acl,
> +	.mkdir_fn = ceph_snap_gmt_mkdir,
> +	.rmdir_fn = ceph_snap_gmt_rmdir,
> +	.getxattr_fn = ceph_snap_gmt_getxattr,
> +	.getxattrat_send_fn = vfs_not_implemented_getxattrat_send,
> +	.getxattrat_recv_fn = vfs_not_implemented_getxattrat_recv,
> +	.listxattr_fn = ceph_snap_gmt_listxattr,
> +	.removexattr_fn = ceph_snap_gmt_removexattr,
> +	.setxattr_fn = ceph_snap_gmt_setxattr,
> +	.chflags_fn = ceph_snap_gmt_chflags,
> +	.get_real_filename_fn = ceph_snap_gmt_get_real_filename,
> +};
> +
> +static_decl_vfs;
> +NTSTATUS vfs_ceph_snapshots_init(TALLOC_CTX *ctx)
> +{
> +	return smb_register_vfs(SMB_VFS_INTERFACE_VERSION,
> +				"ceph_snapshots", &ceph_snap_fns);
> +}
> diff --git a/source3/modules/wscript_build b/source3/modules/wscript_build
> index 8d0e0ee57c1..35010bb0e3b 100644
> --- a/source3/modules/wscript_build
> +++ b/source3/modules/wscript_build
> @@ -522,6 +522,14 @@ bld.SAMBA3_MODULE('vfs_ceph',
>                   cflags=bld.CONFIG_GET('CFLAGS_CEPHFS'),
>                   includes=bld.CONFIG_GET('CPPPATH_CEPHFS'))
>  
> +bld.SAMBA3_MODULE('vfs_ceph_snapshots',
> +                 subsystem='vfs',
> +                 source='vfs_ceph_snapshots.c',
> +                 deps='samba-util',
> +                 init_function='',
> +                 internal_module=bld.SAMBA3_IS_STATIC_MODULE('vfs_ceph_snapshots'),
> +                 enabled=bld.SAMBA3_IS_ENABLED_MODULE('vfs_ceph_snapshots'))
> +
>  bld.SAMBA3_MODULE('vfs_glusterfs',
>                    subsystem='vfs',
>                    source='vfs_glusterfs.c',
> diff --git a/source3/wscript b/source3/wscript
> index c93b6056f29..6830c6b743a 100644
> --- a/source3/wscript
> +++ b/source3/wscript
> @@ -1730,6 +1730,11 @@ main() {
>  
>      if conf.CONFIG_SET("HAVE_CEPH"):
>          default_shared_modules.extend(TO_LIST('vfs_ceph'))
> +        # Unlike vfs_ceph, vfs_ceph_snapshots doesn't depend on libcephfs, so
> +        # can be enabled atop a kernel CephFS share (with vfs_default) in
> +        # addition to vfs_ceph. Still, only enable vfs_ceph_snapshots builds
> +        # if we're building with libcephfs for now.
> +        default_shared_modules.extend(TO_LIST('vfs_ceph_snapshots'))
>  
>      if conf.CONFIG_SET('HAVE_GLUSTERFS'):
>          default_shared_modules.extend(TO_LIST('vfs_glusterfs'))
> -- 
> 2.16.4
> 
> 
> From 03a8d6a1a80394fa6e19cbbc556da7151a6d399e Mon Sep 17 00:00:00 2001
> From: David Disseldorp <ddiss@samba.org>
> Date: Wed, 27 Mar 2019 15:57:45 +0100
> Subject: [PATCH 4/4] docs: add vfs_ceph_snapshots manpage
> 
> Signed-off-by: David Disseldorp <ddiss@samba.org>
> ---
>  docs-xml/manpages/vfs_ceph_snapshots.8.xml | 130 +++++++++++++++++++++++++++++
>  docs-xml/wscript_build                     |   1 +
>  2 files changed, 131 insertions(+)
>  create mode 100644 docs-xml/manpages/vfs_ceph_snapshots.8.xml
> 
> diff --git a/docs-xml/manpages/vfs_ceph_snapshots.8.xml b/docs-xml/manpages/vfs_ceph_snapshots.8.xml
> new file mode 100644
> index 00000000000..7fa2806fd95
> --- /dev/null
> +++ b/docs-xml/manpages/vfs_ceph_snapshots.8.xml
> @@ -0,0 +1,130 @@
> +<?xml version="1.0" encoding="iso-8859-1"?>
> +<!DOCTYPE refentry PUBLIC "-//Samba-Team//DTD DocBook V4.2-Based Variant V1.0//EN" "http://www.samba.org/samba/DTD/samba-doc">
> +<refentry id="vfs_ceph_snapshots.8">
> +
> +<refmeta>
> +	<refentrytitle>vfs_ceph_snapshots</refentrytitle>
> +	<manvolnum>8</manvolnum>
> +	<refmiscinfo class="source">Samba</refmiscinfo>
> +	<refmiscinfo class="manual">System Administration tools</refmiscinfo>
> +	<refmiscinfo class="version">&doc.version;</refmiscinfo>
> +</refmeta>
> +
> +
> +<refnamediv>
> +	<refname>vfs_ceph_snapshots</refname>
> +	<refpurpose>
> +		Expose CephFS snapshots as shadow-copies
> +	</refpurpose>
> +</refnamediv>
> +
> +<refsynopsisdiv>
> +	<cmdsynopsis>
> +		<command>vfs objects = ceph_snapshots</command>
> +	</cmdsynopsis>
> +</refsynopsisdiv>
> +
> +<refsect1>
> +	<title>DESCRIPTION</title>
> +
> +	<para>This VFS module is part of the
> +	<citerefentry><refentrytitle>samba</refentrytitle>
> +	<manvolnum>8</manvolnum></citerefentry> suite.</para>
> +
> +	<para>
> +		The <command>vfs_ceph_snapshots</command> VFS module exposes
> +		CephFS snapshots for use by Samba. When enabled, SMB clients
> +		such as Windows Explorer's Previous Versions dialog, can
> +		enumerate snaphots and access them via "timewarp" tokens.
> +	</para>
> +
> +	<para>
> +		This module can be combined with <command>vfs_ceph</command>,
> +		but <command>vfs_ceph_snapshots</command> must be listed first
> +		in the <command>vfs objects</command> parameter list.
> +	</para>
> +
> +	<para>
> +		CephFS support for ceph.snap.btime virtual extended attributes
> +		is required for this module to work properly. This support was
> +		added via https://tracker.ceph.com/issues/38838.
> +	</para>
> +</refsect1>
> +
> +<refsect1>
> +	<title>CONFIGURATION</title>
> +
> +	<para>
> +		When used atop <command>vfs_ceph</command>,
> +		<command>path</command> refers to an absolute path within the
> +		Ceph filesystem and should not be mounted locally:
> +	</para>
> +
> +	<programlisting>
> +		<smbconfsection name="[share]"/>
> +		<smbconfoption name="vfs objects">ceph_snapshots ceph</smbconfoption>
> +		<smbconfoption name="path">/non-mounted/cephfs/path</smbconfoption>
> +		<smbconfoption name="kernel share modes">no</smbconfoption>
> +	</programlisting>
> +
> +	<para>
> +		<command>vfs_ceph_snapshots</command> can also be used atop a
> +		kernel CephFS mounted share path, without
> +		<command>vfs_ceph</command>. In this case Samba's default VFS
> +		backend <command>vfs_default</command> is used:
> +	</para>
> +
> +	<programlisting>
> +		<smbconfsection name="[share]"/>
> +		<smbconfoption name="vfs objects">ceph_snapshots</smbconfoption>
> +		<smbconfoption name="path">/mnt/cephfs/</smbconfoption>
> +	</programlisting>
> +</refsect1>
> +
> +<refsect1>
> +	<title>OPTIONS</title>
> +
> +	<variablelist>
> +		<varlistentry>
> +		<term>ceph:snapdir = subdirectory</term>
> +		<listitem>
> +		<para>
> +			Allows for the configuration of the special CephFS
> +			snapshot subdirectory name. This parameter should only
> +			be changed from the ".snap" default if the ceph.conf
> +			<command>client snapdir</command> or
> +			<command>snapdirname</command> mount option settings
> +			are changed from their matching ".snap" defaults.
> +		</para>
> +		<para>
> +			Default:
> +			<smbconfoption name="ceph:snapdir">.snap</smbconfoption>
> +		</para>
> +		<para>
> +			Example:
> +			<smbconfoption name="ceph:snapdir">.snapshots</smbconfoption>
> +		</para>
> +		</listitem>
> +		</varlistentry>
> +	</variablelist>
> +</refsect1>
> +
> +<refsect1>
> +	<title>VERSION</title>
> +
> +	<para>
> +		This man page is part of version &doc.version; of the Samba suite.
> +	</para>
> +</refsect1>
> +
> +<refsect1>
> +	<title>AUTHOR</title>
> +
> +	<para>The original Samba software and related utilities
> +	were created by Andrew Tridgell. Samba is now developed
> +	by the Samba Team as an Open Source project similar
> +	to the way the Linux kernel is developed.</para>
> +
> +</refsect1>
> +
> +</refentry>
> diff --git a/docs-xml/wscript_build b/docs-xml/wscript_build
> index 796b685c709..575fb702b46 100644
> --- a/docs-xml/wscript_build
> +++ b/docs-xml/wscript_build
> @@ -72,6 +72,7 @@ vfs_module_manpages = ['vfs_acl_tdb',
>                         'vfs_cap',
>                         'vfs_catia',
>                         'vfs_ceph',
> +                       'vfs_ceph_snapshots',
>                         'vfs_commit',
>                         'vfs_crossrename',
>                         'vfs_default_quota',
> -- 
> 2.16.4
> 

